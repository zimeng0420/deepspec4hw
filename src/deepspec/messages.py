"""Reconstruct logged prompt bodies without removing embedded Markdown fences."""

import re

TOKENS = {
    "description": "@@DESCRIPTION@@",
    "header": "@@HEADER@@",
    "spec": "@@SPEC@@",
    "spec_file": "@@SPEC_FILE@@",
    "task_id": "@@TASK_ID@@",
}


def spec_content(raw):
    return re.sub(
        r"^# (?:Agent Response|Specification) for Task: [^\n]*\n\n", "", raw
    ).strip()


def template_from_log(text, task, raw_spec=""):
    if raw_spec:
        # Substitute spec before description/header: specs often quote both verbatim.
        for value, token in sorted(
            [(raw_spec, TOKENS["spec_file"]), (spec_content(raw_spec), TOKENS["spec"])],
            key=lambda p: len(p[0]),
            reverse=True,
        ):
            if value and value in text:
                text = text.replace(value, token)
    for key in ["description", "header"]:
        if task.get(key):
            text = text.replace(task[key], TOKENS[key])
    return text.replace("Task: " + task["task_id"], "Task: " + TOKENS["task_id"])


def render_log(template, task, spec="", raw_spec=None):
    values = dict(
        task,
        spec=spec,
        spec_file=raw_spec
        if raw_spec is not None
        else f"# Agent Response for Task: {task['task_id']}\n\n{spec}",
    )
    # One regex pass prevents replacing placeholder-like text inside user data/specs.
    reverse = {v: k for k, v in TOKENS.items()}
    return re.sub(
        "|".join(re.escape(t) for t in reverse),
        lambda m: str(values[reverse[m.group()]]),
        template,
    )


def parse_log(text, single_role="user"):
    parts = re.split(r"^## (System|User) Message[^\n]*\n", text, flags=re.M)
    messages = []
    for i in range(1, len(parts), 2):
        role, body = parts[i].lower(), parts[i + 1]
        # Strip only the outer log fences. Inner spec code fences are content.
        body = re.sub(r"^\n*```\n", "", body, count=1)
        body = re.sub(r"\n```\n*\Z", "", body, count=1)
        # Legacy GPT baseline accidentally emitted an extra empty fenced prefix.
        if body.startswith("\n```\n"):
            body = body[len("\n```\n") :]
        messages.append({"role": role, "content": body})
    if not messages:
        raise ValueError("No prompt messages in log")
    if len(messages) == 1:
        messages[0]["role"] = single_role
    return messages


def logged_spec(text, method):
    """Extract the exact spec sent to codegen, including historical whitespace/title."""
    if method not in {"deepspec", "dv", "llmgen"}:
        return None
    if "Generate only a technical specification" in text:
        return None
    rules = [
        (
            "The compressed specification is as follows: ",
            "\n\nThe header you have already known is:",
        ),
        (
            "The specification is as follows:\n",
            "\n\nPlease only reply with the Verilog code",
        ),
        ("You can find the specification as follows:\n\n", None),
        ("You can use the technical specification as follows:", None),
    ]
    for marker, suffix in rules:
        if marker not in text:
            continue
        rest = text.split(marker, 1)[1]
        if suffix and suffix in rest:
            return rest.rsplit(suffix, 1)[0]
        if method == "dv":
            return rest.rsplit("\n\nPlease only reply with the Verilog code", 1)[0]
        if method == "llmgen":
            return rest.rsplit("\nPlease only reply with the Verilog code", 1)[0]
        # mini DeepSpec has two newlines between marker and specification.
        if marker.endswith(":") and rest.startswith("\n\n"):
            rest = rest[2:]
        return re.sub(r"\n```\n*\Z", "", rest, count=1)
    return None
