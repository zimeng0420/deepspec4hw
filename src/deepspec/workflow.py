"""One LangGraph for both model families, preserving observed prompt semantics."""

import json
import math
import operator
from datetime import datetime
from typing import Annotated, Any, TypedDict
from langchain_core.messages import HumanMessage, AIMessage
from langgraph.graph import START, END, StateGraph, add_messages
from langgraph.types import Send
from . import prompts as p
from .schemas import (
    AnalyzeReport,
    SearchQueryList,
    Mindtrace,
    Reflection_A,
    Reflection_B,
)


class State(TypedDict, total=False):
    messages: Annotated[list, add_messages]
    web_research_result: Annotated[list, operator.add]
    query_list: list
    search_query: str
    task_id: str
    task_dir: str
    header: str
    description: str
    circuit_type: str
    analyze_report: Any
    aggregated_results: str
    finalized_answer: str
    final_answer: str
    compressed_answer: str
    content_to_reflect: str
    mindtraced_research_topic: str
    CMB_logic_summary: str
    Timing_logic_summary: str
    retry_count: int
    retry_reflection_count: int
    is_consistent: bool
    is_consistent_B: bool
    info_retention: float
    jaccard_similarity_value: float
    reflection_feedback: str
    reflectionB_feedback: str
    atomic_decomposition: dict
    intersection: list
    union: list
    exhausted: bool


def topic(messages):
    if len(messages) == 1:
        return messages[-1].content
    return "".join(
        ("User: " if isinstance(m, HumanMessage) else "Assistant: ") + m.content + "\n"
        for m in messages
        if isinstance(m, (HumanMessage, AIMessage))
    )


def sequential(state):
    return state.get("circuit_type", "seq").lower().strip() in {"seq", "sequential"}


def cosine(a, b):
    if len(a) != len(b):
        raise ValueError("Embedding dimensions differ")
    denom = math.sqrt(sum(x * x for x in a) * sum(x * x for x in b))
    return sum(x * y for x, y in zip(a, b)) / denom if denom else 0.0


class Workflow:
    def __init__(self, config, provider):
        self.config, self.provider = config, provider
        self.policy = config.policy
        self.events = []
        self.prompt_date = config.prompt_date or datetime.now().strftime("%B %d, %Y")

    def context_fields(self, s):
        fields = {k: v for k, v in s.items() if k != "web_research_result"}
        if not fields.get("aggregated_results"):
            fields["aggregated_results"] = "\n".join(
                json.dumps({"web_research_result": x}, ensure_ascii=False)
                for x in s.get("web_research_result", [])
                if x and x.strip()
            )
        return fields

    def selection(self, s):
        prompt = p.selection_instructions.format(
            current_date=self.prompt_date, research_topic=topic(s["messages"])
        )
        return {
            "analyze_report": self.provider.chat("selection", prompt, AnalyzeReport)
        }

    def query(self, s):
        prompt = p.query_writer_instructions.format(
            analyze_report=s.get("analyze_report", None),
            research_topic=topic(s["messages"]),
        )
        return {
            "query_list": self.provider.chat("query", prompt, SearchQueryList).query
        }

    def research(self, s):
        # Preserve query order; no LLM aggregation call existed in the effective source.
        results = []
        errors = []
        for attempt in range(self.policy.max_search_attempts):
            for query in s.get("query_list", []):
                prompt = p.web_searcher_instructions.format(
                    current_date=self.prompt_date,
                    query=query,
                    research_topic=topic(s["messages"]),
                )
                try:
                    result = self.provider.search(prompt)
                except Exception as exc:
                    errors.append(str(exc))
                    continue
                if result and result.strip():
                    results.append(result)
            if results:
                break
        if not results:
            raise RuntimeError(
                f"No usable search results after {self.policy.max_search_attempts} attempts: {errors}"
            )
        return {"web_research_result": results}

    def finalize(self, s):
        research_topic = topic(s["messages"])
        aggregate = s.get("aggregated_results", "")
        if not aggregate:
            aggregate = "\n".join(
                json.dumps({"web_research_result": x}, ensure_ascii=False)
                for x in s.get("web_research_result", [])
                if x and x.strip()
            )
        prompt = p.answer_instructions_combinational.format(
            aggregated_results=aggregate,
            research_topic=research_topic,
            top_module_header=s.get("header", ""),
            analyze_report=s.get("analyze_report", ""),
        )
        cmb = self.provider.chat("finalize", prompt)
        updates = {
            "CMB_logic_summary": cmb,
            "finalized_answer": cmb,
            "mindtraced_research_topic": "",
            "circuit_type": s.get("circuit_type", "seq").strip().lower(),
            "retry_count": s.get("retry_count", 0),
            "retry_reflection_count": s.get("retry_reflection_count", 0),
        }
        if sequential(s):
            mind = self.provider.chat(
                "finalize",
                p.mindtrace_instructions.format(research_topic=research_topic),
                Mindtrace,
            )
            timing = self.provider.chat(
                "finalize",
                p.answer_instructions_sequential.format(
                    aggregated_results=aggregate,
                    mindtraced_research_topic=mind.mindtraced_research_topic,
                    research_topic=research_topic,
                ),
            )
            updates.update(
                mindtraced_research_topic=mind.mindtraced_research_topic,
                Timing_logic_summary=timing,
                finalized_answer=f"Pure CMB Logic :\n{cmb}\n\n With Timing Logic Summary:\n{timing}",
            )
        return updates

    def after_finalize(self, s):
        if not self.config.reflection:
            return END
        keys = [
            "task_id",
            "task_dir",
            "finalized_answer",
            "messages",
            "mindtraced_research_topic",
            "retry_count",
            "circuit_type",
            "CMB_logic_summary",
            "Timing_logic_summary",
            "retry_reflection_count",
        ]
        payload = {k: s[k] for k in keys if k in s}
        if self.policy.retry_context == "preserve_context":
            payload.update(self.context_fields(s))
        return Send("reflection_simple", payload)

    def simple(self, s):
        content = s["finalized_answer"]
        value = cosine(
            self.provider.embed(topic(s["messages"])), self.provider.embed(content)
        )
        ok = value >= self.policy.stage_a_threshold
        self.events.append(
            {
                "stage": "A",
                "cosine": value,
                "threshold": self.policy.stage_a_threshold,
                "accepted": ok,
                "prior_failures": s.get("retry_count", 0),
            }
        )
        out = {
            k: s[k]
            for k in [
                "messages",
                "task_id",
                "task_dir",
                "circuit_type",
                "retry_reflection_count",
            ]
            if k in s
        }
        if self.policy.retry_context == "preserve_context":
            out.update(self.context_fields(s))
        out.update(
            info_retention=value,
            is_consistent=ok,
            finalized_answer=content,
            compressed_answer=content,
            final_answer=content,
            retry_count=s.get("retry_count", 0) + (not ok),
        )
        if not ok:
            out["reflection_feedback"] = (
                f"Cosine similarity {value:.6f} below {self.policy.stage_a_threshold}"
            )
        return out

    def _exhausted(self, s, stage):
        if self.policy.exhausted == "error":
            raise RuntimeError(f"{stage} reflection retries exhausted")
        return END

    def after_simple(self, s):
        if s["is_consistent"]:
            if not sequential(s):
                return END
            content = s["finalized_answer"]
            payload = {
                k: s.get(k, "")
                for k in [
                    "messages",
                    "task_id",
                    "task_dir",
                    "circuit_type",
                    "mindtraced_research_topic",
                    "aggregated_results",
                ]
            }
            payload.update(
                research_topic=topic(s["messages"]),
                compressed_answer=content,
                finalized_answer=content,
                final_answer=content,
                content_to_reflect=content,
                info_retention=s.get("info_retention", 0),
                retry_count=s.get("retry_count", 0),
                retry_reflection_count=s.get("retry_reflection_count", 0),
                reflection_feedback=s.get("reflection_feedback", ""),
            )
            if self.policy.retry_context == "preserve_context":
                payload.update(self.context_fields(s))
            return Send("reflection", payload)
        if s.get("retry_count", 0) >= self.policy.max_retries:
            return self._exhausted(s, "Stage A")
        # Deliberate fix: old source raised NameError, and its SEQ router returned None.
        return Send("finalize_answer", self.retry_payload(s))

    def reflection(self, s):
        content = s.get("compressed_answer") or s["finalized_answer"]
        mind = s.get("mindtraced_research_topic", "")
        a = self.provider.chat(
            "reflection",
            p.Reflection_A_Instructions.format(
                research_topic=topic(s["messages"]),
                mindtraced_research_topic=mind,
                compressed_answer=content,
            ),
            Reflection_A,
        )
        x, y = (
            a.feedback.information_1_atomic_sets_X,
            a.feedback.information_2_atomic_sets_Y,
        )
        b = self.provider.chat(
            "reflection",
            p.Reflection_B_Instructions.format(
                research_topic=topic(s["messages"]),
                mindtraced_research_topic=mind,
                compressed_answer=content,
                atomic_sets_X="\n".join(f"X{i + 1}: {u}" for i, u in enumerate(x)),
                atomic_sets_Y="\n".join(f"Y{i + 1}: {u}" for i, u in enumerate(y)),
            ),
            Reflection_B,
        )
        jac = min(1.0, max(0.0, len(b.intersection) / len(b.union) if b.union else 0.0))
        self.events.append(
            {
                "stage": "B",
                "jaccard": jac,
                "threshold": self.policy.stage_b_threshold,
                "llm_consistent": b.is_consistent_B,
                "accepted": jac >= self.policy.stage_b_threshold
                or self.policy.stage_b_acceptance == "jaccard_or_llm"
                and b.is_consistent_B,
                "prior_retries": s.get("retry_reflection_count", 0),
            }
        )
        out = {
            k: s[k]
            for k in [
                "messages",
                "task_id",
                "task_dir",
                "circuit_type",
                "retry_reflection_count",
                "info_retention",
            ]
            if k in s
        }
        if self.policy.retry_context == "preserve_context":
            out.update(self.context_fields(s))
        out.update(
            jaccard_similarity_value=jac,
            reflectionB_feedback=b.reflectionB_feedback,
            finalized_answer=content,
            content_to_reflect=content,
            compressed_answer=content,
            is_consistent_B=b.is_consistent_B,
            atomic_decomposition=a.model_dump(),
            intersection=b.intersection,
            union=b.union,
        )
        return out

    def retry_payload(self, s):
        if self.policy.retry_context == "preserve_context":
            return self.context_fields(s)
        keys = [
            "messages",
            "task_id",
            "task_dir",
            "circuit_type",
            "mindtraced_research_topic",
            "CMB_logic_summary",
            "Timing_logic_summary",
        ]
        out = {k: s.get(k, "") for k in keys}
        out.update(
            research_topic=topic(s["messages"]),
            retry_count=s.get("retry_count", 0),
            retry_reflection_count=s.get("retry_reflection_count", 0),
            reflection_feedback=s.get(
                "reflectionB_feedback", s.get("reflection_feedback", "")
            ),
            aggregated_results=s.get("aggregated_results", ""),
        )
        return out

    def after_reflection(self, s):
        if s["jaccard_similarity_value"] >= self.policy.stage_b_threshold or (
            self.policy.stage_b_acceptance == "jaccard_or_llm" and s["is_consistent_B"]
        ):
            return END
        if s.get("retry_reflection_count", 0) >= self.policy.max_retries:
            return self._exhausted(s, "Stage B")
        payload = self.retry_payload(s)
        payload["retry_reflection_count"] = s.get("retry_reflection_count", 0) + 1
        return Send("finalize_answer", payload)

    def compile(self):
        g = StateGraph(State)
        for name, fn in [
            ("selection", self.selection),
            ("generate_query", self.query),
            ("web_research", self.research),
            ("finalize_answer", self.finalize),
            ("reflection_simple", self.simple),
            ("reflection", self.reflection),
        ]:
            g.add_node(name, fn)
        start = (
            "selection"
            if self.config.selection
            else "generate_query"
            if self.config.research
            else "finalize_answer"
        )
        g.add_edge(START, start)
        g.add_edge(
            "selection", "generate_query" if self.config.research else "finalize_answer"
        )
        g.add_edge("generate_query", "web_research")
        g.add_edge("web_research", "finalize_answer")
        g.add_conditional_edges("finalize_answer", self.after_finalize)
        g.add_conditional_edges("reflection_simple", self.after_simple)
        g.add_conditional_edges("reflection", self.after_reflection)
        return g.compile(name="deepspec")

    def run(self, task):
        self.events = []
        kind = task["circuit_type"]
        state = dict(
            task,
            messages=[
                {"role": "system", "content": "DeepSpec"},
                {
                    "role": "user",
                    "content": kind
                    + "\n"
                    + task["description"]
                    + "\n"
                    + task["header"],
                },
            ],
        )
        result = self.compile().invoke(state, {"recursion_limit": 100})
        # Last accepted/generated specification, not a stale final_answer from a prior iteration.
        result["reflection_history"] = self.events
        result["accepted_after_exhaustion"] = bool(
            self.events and not self.events[-1]["accepted"]
        )
        return result["finalized_answer"], result
