# 06 - Diff Agent Contract

The diff agent checks whether the CHF branch contains only intended changes.

## Inputs

```txt
baseline_ref
chf_branch
approved_fix_summary
```

## Responsibilities

```txt
run diff against baseline
list changed files
identify unexpected files
write diff result artifact
block if diff is not clean
```

## Commands

```bash
git diff --stat release/tata/1.0..chf/tata-TAT-101-dns-resolution
git diff release/tata/1.0..chf/tata-TAT-101-dns-resolution
```

## Pass Condition

```txt
Changed files match the approved fixes.
```

## Block Condition

```txt
Unexpected files appear in the diff.
```
