"""Lazy SDK adapters; exact request/response records for every new call."""

import json
import os
from pathlib import Path
from datetime import datetime, timezone


class Providers:
    def __init__(self, config, trace_path=None):
        self.config = config
        self.trace_path = Path(trace_path) if trace_path else None
        self.calls = []

    def _record(self, stage, request, response, metadata=None):
        spec = self.config.models[stage]
        record = {
            "stage": stage,
            "requested_model": spec.model,
            "provider": spec.provider,
            "temperature": spec.temperature,
            "max_tokens": spec.max_tokens,
            "request": request,
            "response": response,
            "metadata": metadata or {},
            "time": datetime.now(timezone.utc).isoformat(),
        }
        self.calls.append(record)
        if self.trace_path:
            self.trace_path.parent.mkdir(parents=True, exist_ok=True)
            with self.trace_path.open("a") as f:
                f.write(json.dumps(record, ensure_ascii=False, default=str) + "\n")

    def chat(self, stage, prompt, schema=None):
        spec = self.config.models[stage]
        options = {"model": spec.model, "max_retries": 2}
        if spec.temperature is not None:
            options["temperature"] = spec.temperature
        if spec.max_tokens is not None:
            options["max_tokens"] = spec.max_tokens
        if spec.provider == "google":
            from langchain_google_genai import ChatGoogleGenerativeAI

            client = ChatGoogleGenerativeAI(
                api_key=os.environ["GEMINI_API_KEY"], **options
            )
        else:
            from langchain_openai import ChatOpenAI

            client = ChatOpenAI(api_key=os.environ["OPENAI_API_KEY"], **options)
        if schema:
            raw = client.with_structured_output(schema, include_raw=True).invoke(prompt)
            if raw.get("parsing_error"):
                raise raw["parsing_error"]
            result = raw["parsed"]
            message = raw["raw"]
            response = result.model_dump()
        else:
            message = client.invoke(prompt)
            result = message.content
            response = result
        self._record(
            stage,
            prompt,
            response,
            {
                "response_metadata": message.response_metadata,
                "usage_metadata": getattr(message, "usage_metadata", None),
            },
        )
        return result

    def search(self, prompt):
        from google import genai

        spec = self.config.models["search"]
        response = genai.Client(
            api_key=os.environ["GEMINI_API_KEY"]
        ).models.generate_content(
            model=spec.model,
            contents=prompt,
            config={"tools": [{"google_search": {}}], "temperature": spec.temperature},
        )
        metadata = {
            "model_version": getattr(response, "model_version", None),
            "grounding": [],
        }
        for candidate in response.candidates or []:
            grounding = getattr(candidate, "grounding_metadata", None)
            if grounding:
                metadata["grounding"].append(grounding.model_dump(exclude_none=True))
        self._record("search", prompt, response.text, metadata)
        return response.text or ""

    def embed(self, text):
        from google import genai

        spec = self.config.models["embedding"]
        response = genai.Client(
            api_key=os.environ["GEMINI_API_KEY"]
        ).models.embed_content(model=spec.model, contents=text)
        values = response.embeddings[0].values
        self._record("embedding", text, values)
        return values
