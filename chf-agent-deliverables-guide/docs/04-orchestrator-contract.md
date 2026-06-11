# 04 - Orchestrator Contract

The orchestrator controls the CHF workflow.

It should coordinate smaller agents and helper scripts instead of doing everything itself.

## Inputs

```txt
ticket_id
tenant_name
issue_summary
baseline_ref
approved_fix_commits
target_branch
test_requirements
deployment_target
rollback_reference
```

## Responsibilities

```txt
check required inputs
block if baseline is missing
block if approved fixes are missing
create or request CHF branch name
start CHF execution
request diff review
request test validation
request packaging/tag plan
write closure summary
```

## Flow

```txt
request received
inputs checked
CHF execution completed
diff reviewed
tests checked
packaging prepared
closure recorded
```

## Stop Conditions

```txt
missing baseline
missing approved commits
unresolved cherry-pick conflict
failed tests without approval
unexpected diff files
tag requested before validation
```
