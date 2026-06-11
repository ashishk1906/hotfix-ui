# Template - state_manager.py

Generate this file as:

```txt
deliverables/scripts/state_manager.py
```

## Purpose

Manage CHF workflow state and audit events.

## Responsibilities

```txt
create state file
update current stage
append audit event
write escalation artifact
write closure summary
load state for resume
```

## Suggested CLI

```txt
python state_manager.py init --request <request-json> --out <state-path>
python state_manager.py update-stage --state <state-path> --stage <stage>
python state_manager.py audit --state <state-path> --event <event-name> --details <text>
python state_manager.py close --state <state-path> --out <closure-path>
```

## State Shape

```json
{
  "ticket_id": "TAT-101",
  "tenant_name": "Tata",
  "baseline_ref": "release/tata/1.0",
  "approved_fix_commits": ["abc1234"],
  "chf_branch": "chf/tata-TAT-101-dns-resolution",
  "current_stage": "chf_execution",
  "status": "in_progress",
  "audit": []
}
```

## Rules

```txt
State updates should be explicit.
Resume should use current_stage.
Do not overwrite audit history.
```

