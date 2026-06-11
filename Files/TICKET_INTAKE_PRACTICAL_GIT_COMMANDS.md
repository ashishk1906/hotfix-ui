# Ticket Intake - Practical Git Commands

This file is for the practical Git commands used after a support ticket is created and needs technical investigation.

Example case:

```txt
Ticket: #42
Customer: Airtel
Issue: Unable to login
Tenant branch: release/airtel/v2.3.4
```

## 1. Check Current Git State

Before doing anything, check where you are.

```bash
git status
git branch --show-current
git remote -v
```

Update local references.

```bash
git fetch --all --prune
```

## 2. Confirm The Tenant Or Release Branch

Check whether the running branch exists locally or remotely.

```bash
git branch --all | grep "release/airtel/v2.3.4"
```

If the branch exists on remote, checkout from remote.

```bash
git checkout -b release/airtel/v2.3.4 origin/release/airtel/v2.3.4
```

If it already exists locally, switch to it.

```bash
git checkout release/airtel/v2.3.4
```

Pull latest changes from remote.

```bash
git pull origin release/airtel/v2.3.4
```

## 3. Check Recent History

Look at recent commits on the tenant branch.

```bash
git log --oneline -10
```

Check recent commits with dates and authors.

```bash
git log --oneline --decorate --date=short --pretty=format:"%h %ad %an %s" -10
```

Check files changed in the latest commit.

```bash
git show --stat HEAD
```

## 4. Create An Investigation Branch

Create a branch for debugging the ticket.

```bash
git checkout -b investigation/airtel-42-login-issue
```

Push the branch if others need to see it.

```bash
git push -u origin investigation/airtel-42-login-issue
```

## 5. Search For Login Related Code

Search for login code.

```bash
git grep -n "login"
```

Search for the exact error message.

```bash
git grep -n "Invalid credentials"
```

Search for authentication code.

```bash
git grep -n "auth"
git grep -n "authenticate"
git grep -n "password"
```

## 6. Check Recent Auth Changes

Find commits that touched login or auth files.

```bash
git log --oneline --all -- "*login*"
git log --oneline --all -- "*auth*"
```

Check details of a suspicious commit.

```bash
git show <commit-hash>
```

Check only the changed files in that commit.

```bash
git show --stat <commit-hash>
```

## 7. Compare Tenant Branch With Main

Use this only to understand differences.

Do not merge `main` blindly into a tenant branch.

```bash
git diff --stat release/airtel/v2.3.4..main
```

Check if login or auth files are different.

```bash
git diff release/airtel/v2.3.4..main -- "*login*" "*auth*"
```

## 8. If A Fix Already Exists

If engineering already has a fix branch, inspect it first.

```bash
git fetch origin
git checkout hotfix/airtel-login-fix
git log --oneline -5
git show --stat HEAD
git show HEAD
```

Compare fix branch with tenant branch.

```bash
git diff --stat release/airtel/v2.3.4..hotfix/airtel-login-fix
```

## 9. Cherry-Pick A Fix For Testing

Go back to the investigation branch.

```bash
git checkout investigation/airtel-42-login-issue
```

Cherry-pick the approved fix commit.

```bash
git cherry-pick <commit-hash>
```

If there is a conflict, check conflicted files.

```bash
git status
```

After resolving conflicts:

```bash
git add <resolved-file>
git cherry-pick --continue
```

If the cherry-pick is wrong and must be stopped:

```bash
git cherry-pick --abort
```

## 10. Run Tests

Use the project test command.

Examples:

```bash
npm test
```

```bash
ng test
```

```bash
mvn test
```

```bash
pytest
```

Also check the final diff.

```bash
git diff --stat release/airtel/v2.3.4..investigation/airtel-42-login-issue
```

## 11. Commit Investigation Notes If Needed

If you changed code or added a temporary test, commit clearly.

```bash
git status
git add <file>
git commit -m "Investigate Airtel login issue for ticket 42"
```

Push the branch.

```bash
git push
```

## 12. Create A Proper Hotfix Branch

If the issue needs a real fix, create a hotfix branch from the tenant running branch.

```bash
git checkout release/airtel/v2.3.4
git pull origin release/airtel/v2.3.4
git checkout -b hotfix/airtel-42-login-issue
```

Apply the code fix, then commit.

```bash
git status
git add <fixed-file>
git commit -m "Fix Airtel login issue"
```

Push the hotfix branch.

```bash
git push -u origin hotfix/airtel-42-login-issue
```

## 13. Prepare For CHF If Multiple Fixes Are Needed

If this ticket becomes part of a CHF, create CHF branch from the tenant running branch.

```bash
git checkout release/airtel/v2.3.4
git pull origin release/airtel/v2.3.4
git checkout -b chf/airtel-42-login-issue
```

Cherry-pick only approved commits.

```bash
git cherry-pick <approved-commit-1>
git cherry-pick <approved-commit-2>
```

Review final diff.

```bash
git diff --stat release/airtel/v2.3.4..chf/airtel-42-login-issue
```

Push CHF branch.

```bash
git push -u origin chf/airtel-42-login-issue
```

## 14. Merge After Approval

After QA and approval, merge back into the tenant branch.

```bash
git checkout release/airtel/v2.3.4
git pull origin release/airtel/v2.3.4
git merge --no-ff chf/airtel-42-login-issue
git push origin release/airtel/v2.3.4
```

Create a tag for deployment.

```bash
git tag v2.3.4-airtel-chf1
git push origin v2.3.4-airtel-chf1
```

## 15. Useful Ticket Comment

Add this kind of summary back to the ticket.

```txt
Investigation branch: investigation/airtel-42-login-issue
Tenant branch: release/airtel/v2.3.4
Running version: v2.3.4
Issue: Airtel login failing with "Invalid credentials"
Checked: recent auth commits, tenant branch diff, login logs
Result: Escalated to L2 / Fix branch created / CHF branch created
Next action: QA validation / Engineering review / Deployment
```
