# Template - package_builder.py

Generate this file as:

```txt
deliverables/scripts/package_builder.py
```

## Purpose

Prepare merge, tag, deployment, and rollback handoff details.

This script should not deploy by itself.

## Responsibilities

```txt
read diff result
read test result
verify validation status
generate merge command plan
generate tag command plan
write packaging result artifact
```

## Suggested CLI

```txt
python package_builder.py build-plan --state <state-path> --out <artifact-path>
```

## Output Artifact

```json
{
  "ticket_id": "TAT-101",
  "status": "ready",
  "merge_commands": [
    "git checkout release/tata/1.0",
    "git merge --no-ff chf/tata-TAT-101-dns-resolution"
  ],
  "tag_name": "v1.0.0-tata-chf1",
  "rollback_reference": "v1.0.0-tata-hf1"
}
```

## Rules

```txt
Do not produce ready status if diff failed.
Do not produce ready status if tests failed.
Do not deploy.
```

