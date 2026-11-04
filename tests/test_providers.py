import json
from pathlib import Path
from types import SimpleNamespace
import pytest
from deepspec.config import RunConfig
from deepspec.providers import Providers
from deepspec.schemas import AnalyzeReport

ROOT = Path(__file__).parents[1]


@pytest.mark.parametrize(
    "family,module,class_name,key",
    [
        ("flash", "langchain_google_genai", "ChatGoogleGenerativeAI", "GEMINI_API_KEY"),
        ("gpt4o", "langchain_openai", "ChatOpenAI", "OPENAI_API_KEY"),
    ],
)
def test_stage_models_and_returned_metadata_are_recorded(
    monkeypatch, tmp_path, family, module, class_name, key
):
    import importlib

    cfg = RunConfig.load(ROOT / f"configs/{family}_deepspec.json")
    captured = []
    message = SimpleNamespace(
        content="answer",
        response_metadata={"model_name": "server-reported-model"},
        usage_metadata={"input_tokens": 12, "output_tokens": 2},
    )

    class Client:
        def __init__(self, **kw):
            captured.append(kw)
            self.schema = None

        def with_structured_output(self, schema, include_raw):
            self.schema = schema
            return self

        def invoke(self, prompt):
            if self.schema:
                return {
                    "raw": message,
                    "parsed": AnalyzeReport(
                        Top_Analyze="x", Topic_Analyze="y", Solving_Strategies="z"
                    ),
                    "parsing_error": None,
                }
            return message

    monkeypatch.setattr(importlib.import_module(module), class_name, Client)
    monkeypatch.setenv(key, "offline-dummy-key")
    path = tmp_path / "calls.jsonl"
    provider = Providers(cfg, path)
    for stage in ["selection", "query", "finalize", "reflection", "codegen"]:
        cfg.models[stage].model = "requested-" + stage
        provider.chat(
            stage, "the prompt", AnalyzeReport if stage == "selection" else None
        )
    assert [c["model"] for c in captured] == [
        "requested-" + s
        for s in ["selection", "query", "finalize", "reflection", "codegen"]
    ]
    rows = [json.loads(s) for s in path.read_text().splitlines()]
    assert all(
        row["metadata"]["response_metadata"]["model_name"] == "server-reported-model"
        for row in rows
    )
    assert "offline-dummy-key" not in path.read_text()
