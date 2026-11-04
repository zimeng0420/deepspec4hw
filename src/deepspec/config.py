"""Explicit stage models and named compatibility policies."""

from pathlib import Path
from typing import Literal
from pydantic import BaseModel, Field, ConfigDict


class Model(BaseModel):
    model_config = ConfigDict(extra="forbid")
    provider: Literal["google", "openai"]
    model: str
    temperature: float | None = None
    max_tokens: int | None = None


class Policy(BaseModel):
    model_config = ConfigDict(extra="forbid")
    stage_a_threshold: float = Field(0.7, ge=0, le=1)
    stage_b_threshold: float = Field(0.3, ge=0, le=1)
    stage_b_acceptance: Literal["jaccard_or_llm", "jaccard_only"] = "jaccard_or_llm"
    retry_context: Literal["historical_drop_context", "preserve_context"] = (
        "historical_drop_context"
    )
    exhausted: Literal["accept_last", "error"] = "accept_last"
    max_retries: int = Field(3, ge=0)
    max_search_attempts: int = Field(3, ge=1)
    cluster_selection: Literal["largest", "first"] = "largest"
    no_cluster: Literal["random_compiled", "error"] = "random_compiled"
    ranking_ports: Literal["historical_line_parser"] = "historical_line_parser"


class RunConfig(BaseModel):
    model_config = ConfigDict(extra="forbid")
    run_id: str
    method: Literal["baseline", "llmgen", "deepspec", "vrank", "dv"]
    models: dict[str, Model]
    policy: Policy = Field(default_factory=Policy)
    selection: bool = True
    research: bool = True
    reflection: bool = True
    candidates: int = Field(10, ge=1)
    prompt_date: str | None = None
    prompt_profile: str = ""
    spec_source_run: str | None = None
    provenance: dict = Field(default_factory=dict)

    @classmethod
    def load(cls, path):
        result = cls.model_validate_json(Path(path).read_text())
        required = {"codegen"}
        if result.method == "llmgen":
            required.add("specgen")
        if result.method in {"deepspec", "dv"}:
            required |= {
                "selection",
                "query",
                "finalize",
                "reflection",
                "search",
                "embedding",
            }
        missing = required - result.models.keys()
        if missing:
            raise ValueError(f"Missing stage models: {sorted(missing)}")
        return result
