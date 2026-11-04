"""Candidate clustering, including the named historical first-cluster policy."""

import random
from pathlib import Path


def sequence(path):
    if not Path(path).exists():
        return []
    lines = Path(path).read_text(errors="replace").splitlines()
    has = any(l.startswith("[check]") for l in lines)
    out = []
    for line in lines:
        if not line.strip() or (has and not line.startswith("[check]")):
            continue
        if line.startswith("[check]"):
            line = line[7:].strip()
        rec = {}
        for part in map(str.strip, line.split(",")):
            if part.startswith("scenario"):
                try:
                    rec["scenario"] = int(part.split(":")[1])
                except (ValueError, IndexError):
                    continue
            elif "=" in part:
                k, v = part.split("=", 1)
                v = v.strip()
                if not any(c in v.lower() for c in "xz"):
                    try:
                        v = int(v)
                    except ValueError:
                        pass
                rec[k.strip()] = v
        if "scenario" in rec:
            out.append(rec)
    return out


def historical_ports(code):
    ports = []
    inside = False
    for line in code.splitlines():
        line = line.strip()
        if line.startswith("module "):
            inside = True
            continue
        if inside and line.startswith(");"):
            break
        if inside and line.startswith("output"):
            text = line[6:].strip()
            if text.startswith("[") and "]" in text:
                text = text.split("]", 1)[1].strip()
            for part in text.split(","):
                name = part.strip().rstrip(";").rstrip(")")
                if name and name not in ports:
                    ports.append(name)
    return ports


def cluster_candidates(candidates, ports):
    clusters = {}
    for i, c in enumerate(candidates):
        seq = c.get("sequence", [])
        if not seq:
            continue
        key = tuple(
            tuple([r.get("scenario", 0)] + [r.get(p) for p in ports]) for r in seq
        )
        clusters.setdefault(key, []).append(i)
    for ids in clusters.values():
        ids.sort(key=lambda i: (-int(candidates[i].get("passed", False)), i))
    return list(clusters.values())


def choose(candidates, ports, policy="largest", no_cluster="random_compiled", rng=None):
    clusters = cluster_candidates(candidates, ports)
    if not clusters:
        eligible = [i for i, c in enumerate(candidates) if c.get("passed", False)]
        if not eligible or no_cluster == "error":
            raise ValueError("No nonempty output clusters")
        return (rng or random.Random()).choice(eligible), []
    if policy == "largest":
        clusters.sort(
            key=lambda ids: (
                len(ids),
                sum(candidates[i].get("passed", False) for i in ids),
                -min(ids),
            ),
            reverse=True,
        )
    elif policy != "first":
        raise ValueError(f"Unknown cluster policy: {policy}")
    return clusters[0][0], clusters


def inspect_run(root):
    from collections import Counter

    stats = Counter()
    evidence = []
    for task in sorted(Path(root).iterdir()):
        if not task.is_dir():
            continue
        final = task / "final_golden_sim/top_module.v"
        if not final.exists():
            stats["no_final"] += 1
            continue
        selected = final.read_text(errors="replace")
        candidates = []
        for i in range(1, 11):
            code = task / f"RTL_{i}/top_module.v"
            info = task / f"RTL_{i}run_info.txt"
            candidates.append(
                {
                    "code": code.read_text(errors="replace") if code.exists() else None,
                    "sequence": sequence(task / f"RTL_{i}/TBout.txt"),
                    "passed": info.exists()
                    and "iverilog simulation passed!"
                    in info.read_text(errors="replace"),
                }
            )
        matches = [i for i, c in enumerate(candidates) if c["code"] == selected]
        if not matches:
            stats["final_not_candidate"] += 1
            continue
        clusters = cluster_candidates(
            candidates, historical_ports(candidates[0]["code"] or "")
        )
        if not clusters:
            stats["no_clusters"] += 1
            continue
        first = clusters[0]
        size = max(map(len, clusters))
        largest = {i for g in clusters if len(g) == size for i in g}
        if len(first) < size:
            first_pick = bool(set(matches) & set(first))
            largest_pick = bool(set(matches) & largest)
            stats["discriminating_tasks"] += 1
            stats["first_pick"] += first_pick
            stats["largest_pick"] += largest_pick
            evidence.append(
                {
                    "task_id": task.name,
                    "matching_candidates": [i + 1 for i in matches],
                    "first_cluster": [i + 1 for i in first],
                    "largest_members": [i + 1 for i in sorted(largest)],
                    "first_pick": first_pick,
                    "largest_pick": largest_pick,
                    "ambiguous": first_pick and largest_pick,
                }
            )
    return {"counts": dict(stats), "evidence": evidence}
