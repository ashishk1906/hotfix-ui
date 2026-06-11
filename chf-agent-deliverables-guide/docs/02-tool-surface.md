# 02 - Tool Surface

This file defines the minimum tool assumptions for generated agents.

## Orchestrator Tools

The orchestrator may use:

```txt
read_file
write_file
spawn_agent if available
wait_for_all if available
```

If child-agent tools are not available, the orchestrator should use file handoffs:

```txt
write next task file
stop or wait for artifact
resume from saved state
```

## Agent Tools

CHF, diff, and pack agents may use:

```txt
read_file
write_file
run_command
```

## Script Responsibility

Scripts should run deterministic operations:

```txt
git checkout
git diff
git show
git cherry-pick
test commands
state updates
artifact writing
```

## Rule

```txt
Agents should not fake command results.
Agents should read script or command output and decide the next step.
```
