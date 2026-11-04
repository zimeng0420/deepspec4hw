class FakeProvider:
    def __init__(self, b_failures=0, low_a=0, queries=1):
        self.calls = []
        self.b_failures = b_failures
        self.low_a = low_a
        self.b_calls = 0
        self.embeds = 0
        self.plain = 0
        self.queries = queries

    def chat(self, stage, prompt, schema=None):
        self.calls.append((stage, prompt, schema.__name__ if schema else None))
        if schema:
            name = schema.__name__
            if name == "AnalyzeReport":
                data = dict(
                    Top_Analyze="module insight",
                    Topic_Analyze="topic insight",
                    Solving_Strategies="strategy",
                )
            elif name == "SearchQueryList":
                data = dict(
                    query=[f"query {i}" for i in range(self.queries)],
                    rationale="reason",
                )
            elif name == "Mindtrace":
                data = dict(
                    mindtrace_schemas=[], mindtraced_research_topic="refined topic"
                )
            elif name == "Reflection_A":
                data = {
                    "feedback": dict(
                        atomic_information_decomposition="decompose",
                        information_1_atomic_sets_X=["requirement"],
                        information_2_atomic_sets_Y=["detail"],
                    )
                }
            elif name == "Reflection_B":
                self.b_calls += 1
                fail = self.b_calls <= self.b_failures
                data = dict(
                    is_consistent_B=not fail,
                    intersection=[] if fail else ["unit"],
                    union=["unit"],
                    jaccard_similarity_value=0 if fail else 1,
                    reflectionB_feedback="try again" if fail else "ok",
                )
            else:
                raise AssertionError(name)
            return schema.model_validate(data)
        self.plain += 1
        return f"generated summary {self.plain}"

    def search(self, prompt):
        self.calls.append(("search", prompt, None))
        return "web evidence"

    def embed(self, text):
        self.calls.append(("embedding", text, None))
        self.embeds += 1
        return (
            [0.0, 1.0]
            if self.embeds % 2 == 0 and self.embeds // 2 <= self.low_a
            else [1.0, 0.0]
        )
