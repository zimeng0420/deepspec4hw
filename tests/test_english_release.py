import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).parents[1]


def tool(name):
    spec = importlib.util.spec_from_file_location(name, ROOT / "tools" / (name + ".py"))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_entire_public_checkout_is_english():
    result = tool("check_english").check_repository(ROOT)
    assert result["checked_files"] >= 107809
    assert result["failures"] == []


def test_guard_detects_literal_and_escaped_text_without_banned_fixtures():
    check = tool("check_english")
    assert check.has_han(chr(0x4E00))
    assert check.has_han("\\" + "u" + format(0x4E00, "04x"))
    assert not check.has_han("DeepSpec for hardware")


def test_translated_artifacts_retain_source_provenance_and_executable_ast():
    normalize = tool("normalize_english")
    translations = normalize.translations()
    artifacts = {
        item["path"]: item
        for item in map(
            json.loads,
            (ROOT / "experiments/artifacts.sha256.jsonl").read_text().splitlines(),
        )
    }
    assert len(translations) == 11
    for path, record in translations.items():
        item = artifacts[path]
        assert item["source_sha256"] == record["source_sha256"]
        assert item["source_sha256"] != item["sha256"]
        assert item["sha256"] == record["sha256"]
        if "executable_ast_sha256" in record:
            assert (
                normalize.executable_ast_sha256((ROOT / path).read_text())
                == record["executable_ast_sha256"]
            )
