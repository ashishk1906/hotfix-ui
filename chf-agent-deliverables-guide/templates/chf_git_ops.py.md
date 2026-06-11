# Template - chf_git_ops.py

Generate this file as:

```txt
deliverables/scripts/chf_git_ops.py
```

## Purpose

This script performs deterministic Git operations for CHF.

The agent decides what should happen. This script only executes Git commands and returns structured results.

## Responsibilities

```txt
check git status
fetch remote refs
checkout baseline
create CHF branch
inspect commit
cherry-pick commit
handle conflict status
push CHF branch
```

## Suggested CLI Commands

```txt
python chf_git_ops.py status --repo <path>
python chf_git_ops.py create-branch --repo <path> --baseline <ref> --branch <chf-branch>
python chf_git_ops.py inspect-commit --repo <path> --commit <hash>
python chf_git_ops.py cherry-pick --repo <path> --commit <hash>
python chf_git_ops.py push-branch --repo <path> --branch <chf-branch>
```

## Output Shape

Every command should print JSON:

```json
{
  "ok": true,
  "operation": "inspect_commit",
  "exit_code": 0,
  "stdout": "...",
  "stderr": "",
  "data": {}
}
```

## Rules

```txt
Never hide git errors.
Return exit_code.
Return conflict status when cherry-pick fails.
Do not run destructive commands.
```

