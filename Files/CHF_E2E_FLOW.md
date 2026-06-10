# CHF Flow Understanding

## Purpose

This document explains the end-to-end CHF flow in a practical way.

CHF means **Cumulative HotFix**. It is used when one tenant or one release version needs approved fixes to be shipped safely without pulling unrelated work from `main`.

The most important rule is:

```txt
Start from the tenant's exact running state.
Include only approved fixes.
```

## When CHF Is Needed

CHF is needed when:

- a tenant is running a specific release or tenant branch
- one or more fixes are approved for that tenant/version
- the fixes need to be shipped together
- we need a clear branch, tag, deployment, and rollback path

If only one urgent fix is needed, it may be a normal HotFix.

If multiple approved fixes need to go together, it becomes a CHF.

## Stakeholders

### Customer Or Tester

Reports the issue.

Provides the problem details, expected behavior, screenshots, logs, affected environment, and steps to reproduce if available.

### Support Team

Creates the internal ticket.

The ticket should include tenant name, severity, affected version, reproduction details, and the customer report link.

### Developer

Creates the fix.

The developer provides the fix branch or commit, review details, and test evidence.

### Release Engineer

Runs the CHF process.

The release engineer confirms the tenant baseline, selects approved fixes, creates the CHF branch, applies fixes, coordinates testing, merges, tags, and prepares the release for deployment.

### QA / Test Engineer

Validates the CHF.

QA checks that the original issue is fixed and existing tenant behavior is not broken.

### DevOps / Deployment Owner

Deploys the verified hotfix.

They handle rollout, rollback readiness, and post-deploy checks.

### Support / Customer Success

Updates the customer after deployment.

They share the final status, deployed tag, and confirmation.

## Main Inputs

Before starting a CHF, these inputs should be known:

```txt
Ticket ID
Tenant name
Issue summary
Severity
Affected environment
Tenant running branch/tag/commit
Approved fix branch or commits
Test requirements
Deployment target
Rollback requirement
```

If the tenant running state is not known, the CHF should not start.

If the approved fixes are not clear, the CHF should not start.

## Identify Tenant's Exact Running State

This is the first real step.

The release engineer should confirm:

```txt
Which tenant is affected?
Which version is running?
Which branch, tag, or commit represents that deployed version?
Does the tenant already have previous patches?
Does the tenant have more than one active version?
```

Example:

```txt
Tenant: Tata
Running branch: release/tata/1.0
Running tag: v1.0.0-tata-hf1
Running commit: 3d8cc09
```

The CHF branch must be created from this baseline.

Do not create the CHF from latest `main` unless the tenant is actually running `main`, which is usually not the case.

## Select Fixes To Include

The release engineer should identify exactly which fixes will go into the CHF.

For each fix, confirm:

```txt
commit hash
source branch
linked ticket
approval status
whether it is relevant to this tenant/version
whether it has unrelated changes
whether it depends on another commit
```

Only approved fixes should be included.

CHF should not mean "merge everything available".

## End-To-End Flow

```txt
Issue is reported
        |
Support creates internal ticket
        |
Developer creates fix branch/commit
        |
Release engineer confirms tenant running state
        |
Release engineer selects approved fixes
        |
CHF branch is created from tenant baseline
        |
Approved fixes are cherry-picked
        |
Tests and smoke checks are run
        |
Diff is reviewed against baseline
        |
CHF is merged into tenant/release branch
        |
Tag is created
        |
Build/deployment artifact is prepared
        |
Deployment is done
        |
Post-deploy checks are run
        |
Fix is carried forward if needed
        |
Job is closed
```

## Step 1: Ticket Intake

The issue starts from a customer, user, or test engineer.

Support converts it into an internal ticket.

Expected output:

```txt
Ticket ID
Issue summary
Severity
Affected tenant
Affected version/environment
```

## Step 2: Fix Creation

The developer creates the fix on a branch based on the affected release or tenant baseline.

Expected output:

```txt
Fix branch
Fix commit
Review result
Test evidence
```

## Step 3: CHF Planning

The release engineer decides whether this is a HotFix or CHF.

For CHF, the release engineer selects all approved fixes that should ship together.

Expected output:

```txt
Job type
Tenant baseline
Approved fix list
```

## Step 4: Create CHF Branch

Create the CHF branch from the tenant's running baseline.

Example:

```bash
git checkout -b chf/tata-TAT-101-dns-resolution release/tata/1.0
```

Expected output:

```txt
CHF branch created from correct baseline
```

## Step 5: Apply Fixes

Cherry-pick the approved commits into the CHF branch.

Before applying a commit, inspect it.

Example:

```bash
git show --stat abc1234
git show abc1234
git cherry-pick abc1234
```

Expected output:

```txt
Selected fixes applied
Conflicts identified if any
```

If there is a conflict, stop and resolve it carefully.

## Step 6: Test And Review

Run tests and smoke checks.

Then compare the CHF branch against the baseline.

Example:

```bash
git diff release/tata/1.0..chf/tata-TAT-101-dns-resolution --stat
```

Expected output:

```txt
Test result
Smoke check result
Changed file list
Confirmation that only intended changes are included
```

If unexpected files appear, stop and review before continuing.

## Step 7: Merge And Tag

After validation, merge the CHF branch into the tenant or release branch.

Example:

```bash
git checkout release/tata/1.0
git merge --no-ff chf/tata-TAT-101-dns-resolution
```

Create a clear tag.

Example:

```txt
v1.0.0-tata-chf1
```

Expected output:

```txt
Merge commit
Hotfix tag
```

## Step 8: Build And Deploy

Build the artifact from the verified tag.

Deploy it to the tenant environment.

Expected output:

```txt
Deployment artifact
Deployment status
Rollback readiness
Post-deploy check result
```

Deployment should be staged if the tenant footprint is large.

## Step 9: Carry Forward If Needed

After tenant deployment, check whether the same issue exists in:

```txt
main
active release branches
other tenant branches
```

If the fix is generic, carry it forward.

If the fix is tenant-specific, keep it only in the tenant branch.

Expected output:

```txt
Carry-forward decision
Propagation commit or PR if needed
```

## Step 10: Close The Job

Close the CHF only after the important details are recorded.

Record:

```txt
final branch
final commit
final tag
deployment result
carry-forward decision
rollback notes if any
```

## Data Flow

```txt
Customer report
        |
Support ticket
        |
Developer fix branch/commit
        |
Release engineer CHF job
        |
CHF branch
        |
Test and diff result
        |
Merge and tag
        |
Deployment
        |
Customer update
```

## Inputs And Outputs By Stage

| Stage | Input | Output |
| --- | --- | --- |
| Ticket intake | Customer report | Internal ticket |
| Fix creation | Ticket details | Fix branch/commit |
| CHF planning | Tenant baseline, approved fixes | CHF plan |
| Branch creation | Tenant baseline | CHF branch |
| Apply fixes | Approved commits | Applied fixes |
| Test/review | CHF branch | Test result and diff summary |
| Merge/tag | Validated CHF branch | Merge commit and tag |
| Deploy | Verified tag/artifact | Deployment result |
| Carry forward | Fix decision | Main/release propagation if needed |
| Closure | Final results | History entry |

## Deterministic Parts

These parts should produce the same result when the same input is provided.

### Baseline Selection

Same tenant and same deployed version should give the same baseline branch/tag/commit.

### Branch Naming

Same tenant, ticket, and description should give a predictable CHF branch name.

Example:

```txt
chf/tata-TAT-101-dns-resolution
```

### Fix Selection

Same approved fix list should include the same commits.

Unapproved commits should not be included.

### Diff Result

Same baseline and same CHF branch should give the same changed-file list.

### Tag Naming

Same tenant, base version, and CHF number should give a predictable tag.

Example:

```txt
v1.0.0-tata-chf1
```

## Human Decision Parts

Some parts need human judgment.

Examples:

```txt
severity
HotFix or CHF decision
which fixes are approved
conflict resolution
whether a failed test is acceptable
whether to carry forward
deployment timing
rollback decision
```

These decisions should be recorded in the job history.

## Practical Rules

```txt
Start from the tenant's actual running state.
Do not start from latest main by default.
Include only approved fixes.
Do not include unrelated changes.
Inspect commits before cherry-pick.
Review diff before merge.
Test before tag and deployment.
Create a clear tag.
Record branch, commit, tag, and deployment result.
Carry forward only when needed.
```

## Simple Example

```txt
Ticket: TAT-101
Tenant: Tata
Issue: dns-resolution-fix
Baseline: release/tata/1.0
Source fix: hotfix/dhcp-scope-exhaustion
CHF branch: chf/tata-TAT-101-dns-resolution
Tag: v1.0.0-tata-chf1
```

Flow:

```txt
Confirm Tata is running release/tata/1.0
Create CHF branch from release/tata/1.0
Cherry-pick approved DNS fix
Run tests and smoke checks
Review diff against release/tata/1.0
Merge back into release/tata/1.0
Create tag v1.0.0-tata-chf1
Deploy to Tata
Carry forward to main if the fix is generic
Close the job
```

## Final Summary

CHF is a controlled flow for shipping approved fixes to a tenant or release version.

The key is simple:

```txt
Start from the exact running state.
Apply only approved fixes.
Validate the result.
Tag and deploy safely.
Record what happened.
```
