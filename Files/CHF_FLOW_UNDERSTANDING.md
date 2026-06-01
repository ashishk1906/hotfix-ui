# Understanding Of CHF Flow

## Scenario

We have one repository with three branch lanes:

```txt
upstream/main
release
tenant
```

### upstream/main

This contains the latest code. New features, bug fixes, and regular development changes continue to move here.

### release

This contains tagged product releases such as:

```txt
v1.0.0
v1.1.0
v1.2.0
```

A release branch or tag represents a tested product version.

### tenant

This represents the actual version running for a tenant.

Different tenants may be running different versions. For example:

```txt
Tenant A -> v1.0.0
Tenant B -> v1.1.0
Tenant C -> v1.0.0 with an earlier patch
```

A tenant may also need its own patch because it cannot immediately upgrade to the latest release.

## Problem

Assume `v1.0.0` was released some time ago.

After that release, development continued on `main`. There may now be many commits:

```txt
feature changes
bug fixes
other tenant fixes
```

Now, a tenant running `v1.0.0` reports an urgent issue.

We should not move all the latest `main` changes into that tenant branch. We only want the minimum required fix for that issue.

That is the purpose of the CHF flow.

## Expected Input

Before creating a hotfix, we need:

```txt
Tenant
Tenant's currently running version
Issue / ticket
Affected service or module
Target tenant branch
Relevant fix commit, PR, or patch
```

Example:

```txt
Tenant: Tenant A
Running version: v1.0.0
Issue: Payment retry failure
Target branch: tenant/tenant-a/v1.0.0
Fix commit: abc123
```

## Hotfix Creation Steps

### 1. Identify The Tenant Baseline

First, determine exactly what is running for the tenant.

Check:

```txt
tenant name
deployed version
release tag
existing tenant patches
current tenant branch
```

Example:

```txt
Tenant A is running v1.0.0
Tenant A already has patch-01
Current branch is tenant/tenant-a/v1.0.0-patch-01
```

This matters because the new hotfix must be created from the tenant's actual running code, not blindly from `main`.

### 2. Understand The Issue

Link the issue or ticket and identify the required fix.

Check:

```txt
what is broken
which module is affected
whether the issue exists in the tenant version
whether the fix already exists on main
whether there is an existing PR or commit
```

At this point, we should know the smallest code change required.

### 3. Find The Relevant Fix

If the fix already exists on `main`, identify the commit or commits.

Example:

```txt
abc123 - Fix payment retry handling
def456 - Add missing validation test
```

Do not include unrelated commits.

If the fix does not exist yet, create and review the fix first.

### 4. Check Dependencies

Before applying the fix, check whether it depends on other commits.

For example:

```txt
Does abc123 depend on a helper added in another commit?
Does it require a schema change?
Does it require a configuration change?
Does it depend on a newer library version?
```

If a dependency is required, include only the minimum supporting commits.

If the fix cannot be safely isolated, stop and ask for review instead of pulling a large set of changes from `main`.

### 5. Create A Hotfix Branch

Create a new hotfix branch from the tenant's current running branch.

Example:

```txt
tenant/tenant-a/v1.0.0-patch-01
        |
        +-- hotfix/tenant-a/payment-retry
```

The new branch should start from the exact tenant baseline.

### 6. Apply The Fix

Apply the selected commits to the hotfix branch.

Usually this means cherry-picking the required commits.

Example:

```txt
cherry-pick abc123
cherry-pick def456
```

If a conflict occurs:

```txt
stop the workflow
report the conflicting files
ask for user/developer input
resolve the conflict
continue after confirmation
```

The workflow should not silently resolve risky conflicts.

### 7. Validate The Hotfix

Run validation against the tenant hotfix branch.

Minimum checks:

```txt
build passes
unit tests pass
affected feature is verified
tenant-specific checks pass
no unrelated changes are included
```

Also compare the diff against the tenant baseline.

The diff should contain only the intended fix and its required dependencies.

### 8. Review Risk

Before deployment, review the risk.

Consider:

```txt
number of changed files
criticality of affected module
database changes
configuration changes
dependency updates
test results
tenant impact
rollback possibility
```

If the risk is high, require approval before deployment.

### 9. Deploy To Tenant Environment

Deploy the hotfix branch to the tenant environment.

Track:

```txt
deployment start
deployment result
health checks
smoke tests
rollback status if deployment fails
```

If deployment succeeds, mark the hotfix as completed.

If deployment fails, stop and either fix the issue or roll back.

### 10. Record The Result

Store the final details:

```txt
tenant
original tenant version
hotfix branch
issue / ticket
applied commits
validation result
deployment result
owner
approver
created time
updated time
final status
```

This gives us an audit trail.

### 11. Merge The Fix Back Where Required

After the tenant hotfix is completed, check whether the fix also needs to move into other branch lanes.

Possible actions:

```txt
Ensure fix exists on main
Include fix in the next release
Apply fix to other affected tenant branches if needed
```

This prevents the same issue from returning in future releases.

## Simple Flow Summary

```txt
Identify tenant's running version
        |
Understand issue
        |
Find minimum fix commits
        |
Check dependencies
        |
Create branch from tenant baseline
        |
Apply commits
        |
Resolve conflicts if required
        |
Build and test
        |
Review risk
        |
Deploy to tenant
        |
Record result
        |
Merge fix forward where needed
```

## Example

```txt
Tenant A is running v1.0.0-patch-01.

A payment retry issue is reported.

The fix already exists on main as commit abc123.

We verify that abc123 has no additional dependencies.

We create:
hotfix/tenant-a/payment-retry

from:
tenant/tenant-a/v1.0.0-patch-01

We cherry-pick abc123.

Build and tests pass.

We deploy the hotfix to Tenant A.

We verify the payment retry flow.

We record the hotfix as completed.

Finally, we confirm that abc123 is already present on main and include it in the next release branch if required.
```

## Point To Confirm

One detail should be confirmed before implementation:

```txt
Should a tenant hotfix always branch from the tenant's currently deployed branch,
or should it branch from the corresponding release tag and then reapply existing tenant patches?
```

My understanding is that branching from the tenant's actual deployed state is safer because it already includes any tenant-specific patches.
