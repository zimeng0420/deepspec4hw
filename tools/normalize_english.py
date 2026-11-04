"""Apply reviewed English translations while retaining original evidence hashes."""

import ast
import hashlib
import json
from pathlib import Path
from functools import cache

TABLE = Path(__file__).with_name("english_export_translations.json")


@cache
def translations():
    return json.loads(TABLE.read_text())


class StripDocumentation(ast.NodeTransformer):
    def visit_Expr(self, node):
        if isinstance(node.value, ast.Constant) and isinstance(node.value.value, str):
            return None
        return self.generic_visit(node)


def executable_ast_sha256(text):
    tree = StripDocumentation().visit(ast.parse(text))
    return hashlib.sha256(ast.dump(tree, include_attributes=False).encode()).hexdigest()


def normalize_export(path, data):
    record = translations().get(path)
    if record is None:
        return data, {}
    source_sha = hashlib.sha256(data).hexdigest()
    if source_sha != record["source_sha256"]:
        raise ValueError(f"Source changed; review English translation for {path}")
    lines = []
    for line in data.decode("utf-8").splitlines(keepends=True):
        body = line.rstrip("\r\n")
        ending = line[len(body) :]
        key = hashlib.sha256(body.encode()).hexdigest()
        lines.append(record["lines"].get(key, body) + ending)
    output = "".join(lines).encode()
    if hashlib.sha256(output).hexdigest() != record["sha256"]:
        raise ValueError(f"English translation checksum failed for {path}")
    if "executable_ast_sha256" in record:
        if executable_ast_sha256(output.decode()) != record["executable_ast_sha256"]:
            raise ValueError(f"Executable source changed for {path}")
    metadata = {
        k: record[k] for k in ["source_sha256", "source_bytes", "transformation"]
    }
    if "executable_ast_sha256" in record:
        metadata["executable_ast_sha256"] = record["executable_ast_sha256"]
    return output, metadata
