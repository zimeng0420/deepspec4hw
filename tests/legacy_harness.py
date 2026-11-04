"""Execute committed legacy functions with fake clients, never its batch main/imports."""

import ast
import datetime
import json
import logging
import os
import sys
import types
from pathlib import Path
from types import SimpleNamespace
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from langchain_core.runnables import RunnableConfig
from langgraph.graph import StateGraph, START, END
from langgraph.types import Send
from deepspec.workflow import topic

FIXTURES = Path(__file__).parent / "fixtures/legacy"


def load_old(provider, filename="graphDplus.py"):
    schemas = {}
    exec((FIXTURES / "schemas.py").read_text(), schemas)
    state_module = types.ModuleType("legacy_state")
    sys.modules["legacy_state"] = state_module
    state_ns = state_module.__dict__
    state_ns.update(schemas)
    state_ns["__name__"] = "legacy_state"
    state_ast = ast.parse((FIXTURES / "state.py").read_text())
    state_ast.body = [
        n for n in state_ast.body if not isinstance(n, ast.ImportFrom) or n.level == 0
    ]
    exec(compile(state_ast, "legacy/state.py", "exec"), state_ns)
    prompts = {}
    exec((FIXTURES / "prompts.py").read_text(), prompts)
    prompts["get_current_date"] = lambda: "September 14, 2025"
    config = SimpleNamespace(
        selection_model="selection",
        query_generator_model="query",
        answer_model="search",
        reflection_model="reflection",
        number_of_initial_queries=3,
    )

    class Configuration:
        @staticmethod
        def from_runnable_config(_):
            return config

    class Chat:
        def __init__(self, model, **kw):
            self.model = model
            self.schema = None

        def with_structured_output(self, schema):
            wrapped = Chat(self.model)
            wrapped.schema = schema
            return wrapped

        def invoke(self, prompt):
            stage = {
                "AnalyzeReport": "selection",
                "SearchQueryList": "query",
                "Mindtrace": "finalize",
                "Reflection_A": "reflection",
                "Reflection_B": "reflection",
            }.get(getattr(self.schema, "__name__", None), "finalize")
            answer = provider.chat(stage, prompt, self.schema)
            return answer if self.schema else SimpleNamespace(content=answer)

    def search(**kw):
        return SimpleNamespace(
            text=provider.search(kw["contents"]),
            candidates=[
                SimpleNamespace(grounding_metadata=SimpleNamespace(grounding_chunks=[]))
            ],
        )

    def embed(**kw):
        return SimpleNamespace(
            embeddings=[SimpleNamespace(values=provider.embed(kw["contents"]))]
        )

    ns = {
        **state_ns,
        **prompts,
        "os": os,
        "json": json,
        "logging": logging,
        "np": np,
        "cosine_similarity": cosine_similarity,
        "datetime": datetime,
        "RunnableConfig": RunnableConfig,
        "Configuration": Configuration,
        "ChatGoogleGenerativeAI": Chat,
        "ChatOpenAI": Chat,
        "genai_client": SimpleNamespace(
            models=SimpleNamespace(generate_content=search)
        ),
        "genai": SimpleNamespace(
            Client=lambda: SimpleNamespace(models=SimpleNamespace(embed_content=embed))
        ),
        "get_research_topic": topic,
        "write_log_file": lambda *a, **kw: None,
        "resolve_urls": lambda *a, **kw: {},
        "get_citations": lambda *a, **kw: [],
        "insert_citation_markers": lambda text, *a: text,
        "Send": Send,
        "START": START,
        "END": END,
        "StateGraph": StateGraph,
        "logger": logging.getLogger("legacy"),
        "time": SimpleNamespace(sleep=lambda _: None),
    }
    module = types.ModuleType("legacy_graph")
    sys.modules["legacy_graph"] = module
    module.__dict__.update(ns)
    ns = module.__dict__
    ns["__name__"] = "legacy_graph"
    tree = ast.parse((FIXTURES / filename).read_text())
    nodes = []
    for n in tree.body:
        if isinstance(n, ast.FunctionDef):
            nodes.append(n)
        elif isinstance(n, ast.Assign) and any(
            isinstance(t, ast.Name) and t.id in {"builder", "graph"} for t in n.targets
        ):
            nodes.append(n)
        elif (
            isinstance(n, ast.Expr)
            and isinstance(n.value, ast.Call)
            and isinstance(n.value.func, ast.Attribute)
            and isinstance(n.value.func.value, ast.Name)
            and n.value.func.value.id == "builder"
        ):
            nodes.append(n)
    exec(
        compile(ast.Module(body=nodes, type_ignores=[]), "legacy/" + filename, "exec"),
        ns,
    )
    return ns


def initial(task):
    return dict(
        task,
        task_dir="",
        reasoning_model="finalize",
        messages=[
            {"role": "system", "content": "DeepSpec"},
            {
                "role": "user",
                "content": task["circuit_type"]
                + "\n"
                + task["description"]
                + "\n"
                + task["header"],
            },
        ],
    )
