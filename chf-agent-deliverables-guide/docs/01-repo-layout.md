# 01 - Repo Layout

The generated output should be a `deliverables/` folder.

Expected layout:

```txt
deliverables/
  README.md
  agents/
    chf_orchestrator.exs
    chf_agent.exs
    diff_agent.exs
    pack_agent.exs
  prompts/
    chf_orchestrator_prompt.md
    chf_agent_prompt.md
    diff_agent_prompt.md
    pack_agent_prompt.md
  scripts/
    git_helper.py
    diff_helper.py
    test_runner.py
    state_writer.py
  schemas/
    chf_request.schema.json
    chf_state.schema.json
    diff_result.schema.json
    test_result.schema.json
    pack_result.schema.json
  examples/
    sample_chf_request.json
    sample_chf_state.json
    sample_closure_summary.json
```

Names can be adjusted if the harness requires a different convention.

The separation should remain:

```txt
agents decide
scripts execute deterministic work
schemas define artifacts
examples show expected behavior
```
