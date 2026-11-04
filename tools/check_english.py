"""Reject Han-script content, including escaped text, PDF text and Git history."""

import argparse
import io
import json
import re
import subprocess
import threading
from pathlib import Path

RANGES = (
    (0x3400, 0x4DBF),
    (0x4E00, 0x9FFF),
    (0xF900, 0xFAFF),
    (0x20000, 0x2FFFF),
    (0x30000, 0x3347F),
)
HAN = re.compile("[" + "".join(chr(a) + "-" + chr(b) for a, b in RANGES) + "]")
ESCAPED = re.compile(r"\\u([0-9a-fA-F]{4})|\\U([0-9a-fA-F]{8})")


def has_han(text):
    if HAN.search(text):
        return True
    return any(
        any(low <= int(m.group(1) or m.group(2), 16) <= high for low, high in RANGES)
        for m in ESCAPED.finditer(text)
    )


def inspect_bytes(data, label):
    if data.startswith(b"%PDF-"):
        from pypdf import PdfReader

        reader = PdfReader(io.BytesIO(data))
        content = (
            str(reader.metadata)
            + "\n"
            + "\n".join(page.extract_text() or "" for page in reader.pages)
        )
    else:
        try:
            content = data.decode("utf-8")
        except UnicodeDecodeError:
            return [f"{label}: unrecognized non-text artifact"]
    return [f"{label}: Han-script content"] if has_han(content) else []


def check_repository(root, history=False):
    root = Path(root)
    listed = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=root,
    )
    paths = sorted(set(listed.decode().split("\0")) - {""})
    failures = []
    for path in paths:
        if has_han(path):
            failures.append(f"{path}: Han-script filename")
        failures.extend(inspect_bytes((root / path).read_bytes(), path))
    history_objects = 0
    if history:
        objects = (
            subprocess.check_output(["git", "rev-list", "--objects", "--all"], cwd=root)
            .decode()
            .splitlines()
        )
        names = {}
        for entry in objects:
            oid, _, label = entry.partition(" ")
            names[oid] = label or oid
            if has_han(label):
                failures.append(f"{oid}: Han-script historical filename")
        process = subprocess.Popen(
            ["git", "cat-file", "--batch"],
            cwd=root,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
        )

        def feed():
            try:
                for oid in names:
                    process.stdin.write((oid + "\n").encode())
            finally:
                process.stdin.close()

        thread = threading.Thread(target=feed)
        thread.start()
        for _ in names:
            header = process.stdout.readline().decode().split()
            if len(header) != 3:
                raise RuntimeError(f"Unexpected git cat-file response: {header}")
            oid, kind, size = header
            data = process.stdout.read(int(size))
            if process.stdout.read(1) != b"\n":
                raise RuntimeError("Invalid Git object framing")
            if kind in {"blob", "commit", "tag"}:
                failures.extend(inspect_bytes(data, f"history:{names[oid]}"))
                history_objects += 1
        thread.join()
        if process.wait():
            raise RuntimeError("Git history inspection failed")
    return {
        "checked_files": len(paths),
        "checked_history_objects": history_objects,
        "failures": failures,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--root", type=Path, default=Path(__file__).resolve().parents[1]
    )
    parser.add_argument("--history", action="store_true")
    args = parser.parse_args()
    result = check_repository(args.root, args.history)
    print(json.dumps(result, indent=2))
    return int(bool(result["failures"]))


if __name__ == "__main__":
    raise SystemExit(main())
