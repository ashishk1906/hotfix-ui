# 09 - Acceptance

The generated deliverables are acceptable when they can guide a complete CHF flow.

## Required Deliverables

```txt
README.md
agent files
prompt files
helper scripts
schema or example artifact files
sample input
sample output
```

## Required Behavior

The generated workflow must:

```txt
ask for missing baseline
ask for missing approved commits
create CHF branch from baseline
inspect commits before cherry-pick
stop on conflict
run or record tests
review diff before merge
prepare tag only after validation
record closure summary
```

## Sample Input

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

## Expected Result

```txt
CHF branch proposed
approved commit inspected
cherry-pick plan created
test and diff validation required
merge/tag plan prepared after validation
closure summary recorded
```
