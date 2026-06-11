# 07 - Pack Agent Contract

The pack agent prepares merge, tag, and deployment handoff details.

It should run only after tests and diff review are complete.

## Inputs

```txt
target_branch
chf_branch
diff_result
test_result
deployment_target
rollback_reference
```

## Responsibilities

```txt
verify diff passed
verify tests passed or smoke check is recorded
prepare merge commands
prepare tag name
prepare rollback note
write packaging result
```

## Merge Commands

```bash
git checkout release/tata/1.0
git pull origin release/tata/1.0
git merge --no-ff chf/tata-TAT-101-dns-resolution
git push origin release/tata/1.0
```

## Tag Commands

```bash
git tag v1.0.0-tata-chf1
git push origin v1.0.0-tata-chf1
```

## Rule

```txt
Do not create or suggest final tag until validation is complete.
```
