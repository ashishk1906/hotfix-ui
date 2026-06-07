# CHF End-To-End Flow

## Purpose

This document explains the practical end-to-end flow for a CHF, or Cumulative HotFix.

The focus is:

- who is involved
- what data comes in
- what data goes out
- how to identify the tenant's exact running state
- how the CHF moves through its lifecycle
- which parts of the flow should be deterministic

## What CHF Means

CHF means **Cumulative HotFix**.

It is used when one tenant or release version needs one or more approved fixes shipped together as a controlled hotfix.

A CHF should not start from latest `main` by default. It should start from the tenant's actual running state.

## Stakeholders

### Customer / User

Reports the issue.

Provides:

- what happened
- expected behavior
- screenshots or logs
- affected environment
- steps to reproduce, if available

### Support Team

Creates or updates the internal ticket.

Provides:

- customer report link
- severity
- affected tenant
- affected version or environment
- reproduction details

### Developer

Creates the bugfix.

Provides:

- fix branch
- commit hash
- review notes
- test evidence

### Release Engineer

Owns the CHF execution.

Responsible for:

- confirming tenant baseline
- selecting approved fixes
- creating CHF branch
- cherry-picking fixes
- running checks
- merging and tagging
- coordinating deployment

### QA / Test Engineer

Validates the CHF.

Checks:

- original issue is fixed
- no obvious regression
- tenant-specific behavior still works

### DevOps / Deployment Owner

Deploys the verified hotfix.

Handles:

- deployment artifact
- rollout
- rollback readiness
- post-deploy checks

### Customer Success / Support

Communicates final status to the customer.

Shares:

- fix status
- deployed version or tag
- deployment confirmation

## Main Inputs

The CHF process needs these inputs:

```txt
Ticket ID
Tenant / customer name
Issue summary
Severity
Affected environment
Tenant running branch/tag/commit
Source fix branch or commit
Approved fixes to include
Test requirements
Deployment target
Rollback requirement
```

Without the tenant running state and approved fix list, the CHF should not proceed.

## Main Outputs

The CHF process produces:

```txt
CHF branch
Validated fix commits
Test result
Diff review result
Merged tenant/release branch
Hotfix tag
Deployable artifact
Rollback plan
Deployment result
Carry-forward decision
Final history entry
```

## Identifying The Tenant's Exact Running State

This is the first important step.

The release engineer should confirm:

```txt
Which tenant is affected?
Which version is running?
Which branch, tag, or commit represents that version?
Does the tenant already have previous patches?
Are multiple tenant versions active?
```

Example:

```txt
Tenant: Tata
Running branch: tenant/tata-v1.0.0
Running tag: v1.0.0-tata-patch1
Running commit: abc1234
```

If the tenant has multiple active versions, each version may need a separate CHF.

The CHF branch should be created from this exact baseline.

## System Flow

```txt
Issue reported
        |
Support creates internal ticket
        |
Developer creates approved fix
        |
Release engineer confirms tenant running state
        |
Release engineer selects fixes to include
        |
CHF branch is created from tenant baseline
        |
Approved fixes are cherry-picked
        |
CHF branch is tested
        |
Diff is reviewed against tenant baseline
        |
CHF is merged into tenant/release branch
        |
Tag is created
        |
Artifact is built
        |
Deployment is done
        |
Post-deploy checks are run
        |
Fix is carried forward if needed
        |
Job is closed
```

## CHF Lifecycle

### 1. Ticket Intake

The issue is reported by a user, customer, or test engineer.

The support team creates an internal ticket with enough information for engineering.

Output:

```txt
Internal ticket
Issue summary
Severity
Affected tenant/version
```

### 2. Fix Creation

The developer fixes the issue on a branch based on the affected release or tenant baseline.

Output:

```txt
Fix branch
Fix commit
Review result
```

### 3. CHF Planning

The release engineer decides whether this is a single HotFix or a CHF.

For CHF, the release engineer identifies all approved fixes that should ship together.

Output:

```txt
Confirmed job type
Approved fix list
Tenant baseline
```

### 4. CHF Branch Creation

The CHF branch is created from the tenant's exact running baseline.

Example:

```bash
git checkout -b chf/tata-TAT-101-dns-resolution tenant/tata-v1.0.0
```

Output:

```txt
CHF branch
```

### 5. Apply Fixes

Approved commits are cherry-picked into the CHF branch.

Each commit should be inspected before applying.

Output:

```txt
Applied fix commits
Conflict result
```

If there is a conflict, the job is blocked until resolved.

### 6. Test And Review

Run the required tests and review the diff against the baseline.

The goal is to confirm that only intended changes are included.

Output:

```txt
Test result
Smoke test result
Diff summary
Unexpected change check
```

### 7. Merge And Tag

After validation, merge the CHF branch into the tenant or release branch.

Create a clear tag.

Example:

```txt
v1.0.0-tata-chf1
```

Output:

```txt
Merge commit
Hotfix tag
```

### 8. Build And Deploy

Build the deployable artifact from the verified tag.

Deploy to the tenant environment.

Output:

```txt
Deployment artifact
Deployment result
Rollback readiness
Post-deploy check result
```

### 9. Carry Forward

Check whether the same bug exists in `main`, release branches, or other tenant branches.

If the fix is generic, carry it forward.

If it is tenant-specific, keep it only in the tenant lane.

Output:

```txt
Carry-forward decision
Main/release propagation result, if needed
```

### 10. Closure

Close the CHF only after merge, tag, deployment, and carry-forward decision are recorded.

Output:

```txt
Final status
Final branch
Final tag
Final deployment result
Final history entry
```

## Data Flow

### Input Data

```txt
Customer report
Internal ticket
Tenant running state
Approved fix commits
Test requirements
Deployment target
```

### Processing Data

```txt
CHF branch
Cherry-pick result
Test result
Diff result
Merge result
Tag result
Deployment result
```

### Output Data

```txt
Hotfix tag
Updated tenant/release branch
Deployment artifact
Rollback plan
Carry-forward result
Audit/history entry
Customer update
```

## Deterministic Parts

These parts should be deterministic when the same input is provided.

### Baseline Selection

Given the same tenant and deployed version, the same baseline branch/tag/commit should be selected.

### Branch Naming

Given the same tenant, ticket, and description, the CHF branch name should be predictable.

Example:

```txt
chf/tata-TAT-101-dns-resolution
```

### Fix Selection

Given the same approved fix list, the same commits should be included.

Unapproved commits should not be included.

### Diff Review

Given the same baseline and CHF branch, the changed file list should be the same.

### Tag Naming

Given the same tenant, base version, and CHF number, the tag should be predictable.

Example:

```txt
v1.0.0-tata-chf1
```

### Final Output

Given the same baseline and same selected commits, the final merge result should contain the same intended code changes, unless conflicts are resolved differently.

## Non-Deterministic Or Human Decision Parts

Some parts need human judgment.

Examples:

```txt
severity decision
whether to use HotFix or CHF
which fixes are approved
how to resolve conflicts
whether a failed test is acceptable
whether the fix should be carried forward
deployment timing
rollback decision
```

These decisions should be recorded.

## Practical Rules

```txt
Start from the tenant's actual running state.
Include only approved fixes.
Do not include unrelated changes.
Review the diff before merge.
Test before tag and deployment.
Tag the verified result.
Record final branch, tag, commit, and deployment status.
Carry forward only when needed.
```

## Simple Example

```txt
Ticket: TAT-101
Tenant: Tata
Issue: dns-resolution-fix
Tenant baseline: release/tata/1.0
Source fix: hotfix/dhcp-scope-exhaustion
CHF branch: chf/tata-TAT-101-dns-resolution
Tag: v1.0.0-tata-chf1
```

Flow:

```txt
Confirm Tata running release/tata/1.0
Create CHF branch from release/tata/1.0
Cherry-pick approved DNS fix
Run tests and smoke checks
Review diff against release/tata/1.0
Merge back into release/tata/1.0
Create tag v1.0.0-tata-chf1
Deploy to Tata
Carry forward to main if generic
Close the job
```

## Final Summary

The CHF flow is a controlled way to ship one or more approved fixes for a tenant or release.

The key is to start from the exact running state, include only approved fixes, validate the result, tag it clearly, deploy it safely, and record what happened.
