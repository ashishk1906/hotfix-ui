# 05 - CHF Agent Contract

The CHF agent handles branch creation and fix application.

## Responsibilities

```txt
confirm baseline
create CHF branch from baseline
inspect approved commits
cherry-pick approved commits
stop on conflict
record applied commits
write execution result
```

## Git Commands

Check repo state:

```bash
git status
git branch --show-current
git fetch --all --prune
```

Create CHF branch from baseline:

```bash
git checkout release/tata/1.0
git pull origin release/tata/1.0
git checkout -b chf/tata-TAT-101-dns-resolution
```

Inspect commit:

```bash
git show --stat abc1234
git show abc1234
```

Apply commit:

```bash
git cherry-pick abc1234
```

Conflict handling:

```bash
git status
git add <resolved-file>
git cherry-pick --continue
```

Abort:

```bash
git cherry-pick --abort
```

## Rule

```txt
Do not continue after conflict until it is resolved.
Do not apply commits that are not approved.
```
