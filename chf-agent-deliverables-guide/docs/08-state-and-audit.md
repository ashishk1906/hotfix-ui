# 08 - State And Audit

The generated workflow should keep a simple state file and short audit trail.

## State Example

```json
{
  "ticket_id": "TAT-101",
  "tenant_name": "Tata",
  "baseline_ref": "release/tata/1.0",
  "approved_fix_commits": ["abc1234"],
  "chf_branch": "chf/tata-TAT-101-dns-resolution",
  "current_stage": "diff_review",
  "status": "in_progress"
}
```

## Audit Events

Record:

```txt
request_received
baseline_checked
fixes_checked
chf_branch_created
commit_inspected
commit_applied
tests_run
diff_reviewed
packaging_prepared
closure_written
```

## Escalation Artifact

Use this when human decision is needed:

```json
{
  "ticket_id": "TAT-101",
  "status": "needs_human",
  "stage": "diff_review",
  "reason": "Unexpected file found in diff",
  "options": [
    "Reject and inspect commit scope",
    "Approve with written reason",
    "Remove unrelated change and rerun diff"
  ]
}
```

## Resume Rule

```txt
Resume from current_stage.
Do not restart from the beginning unless state is missing.
```
