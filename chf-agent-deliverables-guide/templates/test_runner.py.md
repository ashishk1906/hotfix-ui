# Template - test_runner.py

Generate this file as:

```txt
deliverables/scripts/test_runner.py
```

## Purpose

Run configured tests and write a test result artifact.

## Responsibilities

```txt
read test commands
run commands in repo
capture exit code
capture stdout and stderr
write test result artifact
```

## Suggested CLI

```txt
python test_runner.py run --repo <path> --commands <commands-json> --out <artifact-path>
```

## Output Artifact

```json
{
  "ticket_id": "TAT-101",
  "status": "passed",
  "commands": [
    {
      "command": "npm test",
      "exit_code": 0
    }
  ],
  "notes": "Tests completed"
}
```

## Rules

```txt
Failed test command should produce failed status.
Do not hide stderr.
Do not mark tests passed without running them unless smoke check is explicitly recorded.
```

