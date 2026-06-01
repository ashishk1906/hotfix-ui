# Understanding Of CHF Flow

Suppose we receive a severe ticket:

```txt
PAY-001: Fix payment retry failure for Tenant A
```

Tenant A is currently running an older release, while development has continued on `main`. We should not move all the latest changes into the tenant lane. We only need the required fix and any other approved tenant patches that must ship with it.

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

## 2. Create A Dedicated CHF Branch

Create the CHF branch from the tenant's actual deployed state.

For example:

```bash
git checkout -b chf/tenant-a-payment-retry tenant/tenant-a-v1.0.0-patch-01
```

The branch should not be created from the latest `main` by default. Tenant A may be running an older version with its own patches.

Use a clear branch name tied to the tenant and the fix.

## 3. Identify Or Create The Required Fix

Check whether the issue has already been fixed somewhere, usually on `main` or in an existing PR.

If a reviewed fix already exists, identify the relevant commit:

```txt
abc123 - Fix payment retry handling
```

If no fix exists yet:

- make the smallest required code change
- review it
- test it
- create a focused commit

For example:

```bash
git commit -m "fix(tenant-a): correct payment retry handling"
```

Do not include unrelated features, refactoring, or other changes.

## 4. Add Other Approved Tenant Fixes If Required

CHF means **Cumulative HotFix**.

If Tenant A has other approved pending patches that should ship together, cherry-pick them into the same CHF branch.

For example:

```bash
git cherry-pick abc123
git cherry-pick def456
```

Skip unrelated new features and changes.

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

- If the issue also exists upstream, apply the fix there so that it does not return in future releases.
- If the issue is tenant-specific, keep it only in the tenant lane.
- Record the deployed tags and commits.

## CHF Flow Summary

```txt
Identify tenant's deployed state
        |
Create CHF branch from tenant baseline
        |
Identify or create the required fix
        |
Add other approved tenant fixes if required
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
