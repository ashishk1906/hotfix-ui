# 03 - Artifacts And Handoffs

Agents pass information using small JSON artifacts.

Do not pass large diffs directly in prompts when a file path can be used.

## CHF Request

```json
{
  "ticket_id": "TAT-101",
  "tenant_name": "Tata",
  "issue_summary": "DNS resolution fix",
  "baseline_ref": "release/tata/1.0",
  "approved_fix_commits": ["abc1234"],
  "target_branch": "release/tata/1.0",
  "deployment_target": "Tata production",
  "rollback_reference": "v1.0.0-tata-hf1"
}
```

## Diff Result

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

## Test Result

```json
{
  "ticket_id": "TAT-101",
  "status": "passed",
  "commands": ["npm test"],
  "notes": "Unit tests passed"
}
```

## Pack Result

```json
{
  "ticket_id": "TAT-101",
  "status": "ready",
  "target_branch": "release/tata/1.0",
  "tag_name": "v1.0.0-tata-chf1",
  "rollback_reference": "v1.0.0-tata-hf1"
}
```

## Handoff Rule

```txt
Each agent should write one clear artifact.
The orchestrator reads artifacts and decides the next step.
```
