# Understanding Of CHF Flow

Suppose we receive a severe ticket:

```txt
PAY-001: Fix payment retry failure for Tenant A
```

Tenant A is currently running an older release. The CHF should be created from Tenant A's actual deployed state. We only need the required fix and any other approved tenant patches that must ship with it.

The repository has three branch lanes:

```txt
upstream/main     latest development code
release           tested product releases and tags
tenant            code actually running for tenants
```

Different tenants may be running different versions. A tenant may also have more than one active version or existing patches.

These are the steps to follow for the CHF process.

## 1. Identify The Tenant's Exact Running State

- Find the active branches for the tenant.
- Confirm which versions, tags, or commits are actually deployed.
- Check whether the tenant already has earlier patches.

For example:

```txt
tenant/tenant-a-v1.0.0
tenant/tenant-a-v1.0.0-patch-01
```

If multiple versions are active, each one may need to be handled separately.

## 2. Identify The Fixes To Include

Identify the approved fixes that should be included in the CHF.

These fixes may already exist in `upstream/main`, a release branch, or another approved branch.

For each fix:

```txt
identify the commit hash
confirm that it is approved
confirm that it is relevant for the tenant version
skip unrelated features and changes
```

For example:

```txt
abc123 - Fix payment retry handling
def456 - Add approved validation correction
```

If a required fix does not exist yet, create and review it first. Creating a new fix directly on the tenant CHF branch should be treated as an exception.

## 3. Create A Dedicated CHF Branch

Create the CHF branch from the tenant's actual deployed state.

For example:

```bash
git checkout -b chf/tenant-a-payment-retry tenant/tenant-a-v1.0.0-patch-01
```

The branch should not be created from the latest `main` by default. Tenant A may be running an older version with its own patches.

Use a clear branch name tied to the tenant and the fix.

## 4. Apply The Selected Fixes

Cherry-pick the approved commits into the CHF branch.

For example:

```bash
git cherry-pick abc123
git cherry-pick def456
```

CHF means **Cumulative HotFix**, so the branch can include the required fix and other approved tenant patches that should ship together.

Do not include unrelated new features or changes.

## 5. Test The CHF Branch

- Run unit and integration tests.
- Run tenant-specific checks if they exist.
- Compare the CHF branch against the tenant baseline.
- Confirm that only intended changes are included.
- Deploy to a staging environment matching the tenant setup.
- Verify that the issue is fixed without breaking existing behavior.

## 6. Merge And Tag

After validation:

- merge the CHF branch back into the tenant branch
- create a clear tag for the tenant patch

For example:

```txt
v1.0.0-tenant-a-chf1
```

This tag should include the tenant's previous patches plus the new CHF changes.

## 7. Build And Deploy

- Build the deployable artifact from the verified tag.
- Prepare rollback steps before production deployment.
- Deploy to the tenant environment.
- Run health checks and smoke tests.
- Roll back if the deployment causes an issue.

If the tenant has a large deployment footprint, deploy in stages so that problems can be caught early.

## 8. Repeat For Other Active Tenant Versions

If Tenant A has more than one active version, repeat the branch, test, tag, and deploy steps for each affected version.

## 9. Carry The Fix Forward Where Required

After the tenant CHF is completed, check whether the same issue exists in `main`, the active release branch, or other tenant lanes.

- If the issue also exists upstream, carry the tenant fix forward through a cherry-pick or PR so that it does not return in future releases.
- If the issue is tenant-specific, keep it only in the tenant lane.
- Record the deployed tags and commits.

## CHF Flow Summary

```txt
Identify tenant's deployed state
        |
Identify approved fixes to include
        |
Create CHF branch from tenant baseline
        |
Apply selected fixes
        |
Test in tenant-like environment
        |
Merge into tenant branch and tag
        |
Build and deploy
        |
Repeat for other active versions
        |
Carry fix forward where required
```

## HotFix Instead Of CHF

Sometimes we want to ship only one specific fix and nothing else.

That is a HotFix rather than a cumulative hotfix.

Suppose commit `a1b2c3d` contains the required payment retry fix, but it also contains unrelated changes. We should extract only the required part.

### 1. Apply The Commit Without Committing

```bash
git cherry-pick -n a1b2c3d
```

`-n` applies the changes to the working tree without creating a commit.

### 2. Select Only The Required Changes

```bash
git restore --staged .
git add -p
```

Use `git add -p` to review and stage only the required hunks.

If the required file is already known:

```bash
git add -p path/to/file
```

### 3. Verify The Selected Changes

```bash
git diff --staged
git diff
```

- `git diff --staged` should show only the changes we want to commit.
- `git diff` shows the unwanted changes that are still unstaged.

### 4. Remove Unwanted Changes

```bash
git restore .
```

### 5. Commit The Focused Fix

```bash
git commit -m "fix(tenant-a): correct payment retry handling"
```

After this, continue with testing, tagging, building, and deployment.


