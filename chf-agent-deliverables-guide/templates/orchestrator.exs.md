# Template - orchestrator.exs

Generate this file as:

```txt
deliverables/agents/chf_orchestrator.exs
```

## Purpose

The orchestrator controls the CHF workflow.

It should coordinate the CHF agent, diff agent, pack agent, and deterministic helper scripts.

## Responsibilities

```txt
load CHF request
validate required inputs
load or create state
call tenant/baseline resolution if needed
start CHF execution
request diff analysis
request test execution
request packaging plan
write closure summary
pause when human decision is needed
resume from saved state
```

## Expected Structure

The generated Elixir file should include:

```txt
module or agent definition
input loading
state loading
validation functions
step dispatcher
artifact reading/writing
error/blocked handling
final summary output
```

## Important Rules

```txt
Do not start from main unless baseline confirms it.
Do not continue if required inputs are missing.
Do not tag before diff and test validation.
Do not lose state when paused.
```

## Main Steps

```txt
receive_request
validate_request
resolve_baseline
run_chf_execution
run_diff_analysis
run_tests
prepare_package
write_closure
```

