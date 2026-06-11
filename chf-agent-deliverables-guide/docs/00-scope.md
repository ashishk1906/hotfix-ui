# 00 - Scope

This guide is for creating a CHF agent workflow.

The workflow should help a release engineer:

```txt
confirm tenant baseline
confirm approved fixes
create a CHF branch
apply fixes safely
run validation
review diff
prepare merge and tag
record closure details
```

## What CHF Means

CHF means **Cumulative HotFix**.

It is used when one tenant or release version needs one or more approved fixes without pulling unrelated work from `main`.

## Important Rule

```txt
Do not start from latest main by default.
Start from what the tenant is actually running.
```

## Out Of Scope

```txt
automatic deployment
customer communication
approval policy ownership
large release planning
random merge from main
unapproved fixes
```
