# Template - diff_analyzer.py

Generate this file as:

```txt
deliverables/scripts/diff_analyzer.py
```

## Purpose

Analyze the diff between the tenant baseline and CHF branch.

## Responsibilities

```txt
run git diff --stat
collect changed files
compare changed files with approved scope if provided
detect unexpected files
write diff result artifact
```

## Suggested CLI

```txt
python diff_analyzer.py analyze --repo <path> --baseline <ref> --branch <chf-branch> --out <artifact-path>
```

## Output Artifact

```json
{
  "ticket_id": "TAT-101",
  "status": "passed",
  "baseline_ref": "release/tata/1.0",
  "chf_branch": "chf/tata-TAT-101-dns-resolution",
  "changed_files": ["src/dns/resolver.ts"],
  "unexpected_files": []
}
```

## Rules

```txt
Diff result must be deterministic.
Unexpected files should block packaging.
Do not approve a diff automatically if scope is unclear.
```

