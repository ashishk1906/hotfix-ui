# CHF Agent Deliverables Guide

This folder contains the instruction files needed to generate a harness-ready CHF agent deliverables package.

CHF means **Cumulative HotFix**. It is used when approved fixes must be shipped safely to a specific tenant or release version without taking unrelated changes from `main`.

## What This Guide Produces

An AI coding agent should read these files and generate a final folder named:

```txt
deliverables/
```

That final folder should contain agent files, helper scripts, artifact formats, examples, and a README for running or testing the CHF workflow.

## Read Order

Read these files in order:

```txt
docs/00-scope.md
docs/01-repo-layout.md
docs/02-tool-surface.md
docs/03-artifacts-and-handoffs.md
docs/04-orchestrator-contract.md
docs/05-chf-agent-contract.md
docs/06-diff-agent-contract.md
docs/07-pack-agent-contract.md
docs/08-state-and-audit.md
docs/09-acceptance.md
templates/orchestrator.exs.md
templates/chf_git_ops.py.md
templates/diff_analyzer.py.md
templates/package_builder.py.md
templates/state_manager.py.md
templates/tenant_resolver.py.md
templates/test_runner.py.md
```

## Core Rule

```txt
Start from the tenant's exact running baseline.
Apply only approved fixes.
Validate before merge, tag, or deployment.
```

## How To Use This Guide

Give this folder to Codex, Gemini, or another coding agent and say:

```txt
Read chf-agent-deliverables-guide in README order.
Generate the harness-ready deliverables folder for the CHF workflow.
Keep the implementation simple and deterministic.
Do not invent new CHF rules.
```

## Template Files

The `templates/` folder describes the actual files that should be generated inside `deliverables/`.

These are not the final code files. They are instructions for creating final code files.
