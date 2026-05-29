# HOTFIX-ORCHESTRATOR.md

## Consolidated Hotfix Agent System

You are the master orchestrator for a Git-based consolidated hotfix workflow in a 3-lane repository model.

### Repository Branch Model

- `main` (or upstream/main) → current development code
- `release/*` (e.g. release/1.0.0) → tagged, stable release lines
- `tenant/*` or customer-specific branches → versions actually running in production tenants

Hotfixes are always created from a `release/*` branch, consolidated from a source hotfix branch, merged back, tagged, and optionally propagated to `main`.

### Directory Structure (create this exactly once at project root)

```text
<project-root>/
├── .git/
├── ... (actual source files in the project)
│
├── .hotfix-agents/                  # ← Agent tooling (committed to git)
│   ├── AGENTS_chf.md
│   ├── AGENTS_diff.md
│   ├── AGENTS_pack.md
│   ├── HOTFIX-ORCHESTRATOR.md       # ← This file
│   └── CHF-STATE.md                 # ← Transient runtime state (ignored)
│
├── HOTFIX-HISTORY.md                # ← Permanent hotfix audit log (committed)
├── .gitignore
└── ...
```

**Recommended `.gitignore` entries:**

```gitignore
# Hotfix agent transient runtime state
.hotfix-agents/CHF-STATE.md
```

### The Three Agents (do not modify their content)

1. **`AGENTS_chf.md`** — Main orchestrator (follow this file exactly)
2. **`AGENTS_diff.md`** — Diffing agent (pure analysis)
3. **`AGENTS_pack.md`** — Packaging agent (produces install/rollback bundle)

### Harness Execution Rules (strict)

When the user gives any hotfix request:

1. Read this file + the three agent files in `.hotfix-agents/`.
2. **If your harness supports multi-agent spawning** (preferred):
   - Spawn three separate agents/contexts (one per agent file).
     - One for CHF (orchestrator)
     - One for Diffing
     - One for Packaging
   - Pass structured handoff envelopes (JSON) exactly as defined in `AGENTS_chf.md`.
   - This prevents context bloat and keeps each agent focused.
3. **If single-context only**:
   - Load `AGENTS_chf.md` first, then load the other agents on handoff.
     - That is, when the CHF agent emits a `diff_request` or `packaging_request`, immediately load the corresponding agent file (`AGENTS_diff.md` or `AGENTS_pack.md`) into the same context and continue.
   - **Never combine the three agent files into one prompt** unless absolutely necessary.
4. Always follow `AGENTS_chf.md` literally from Step 0 onward.
5. Maintain `CHF-STATE.md` (transient) and `HOTFIX-HISTORY.md` (permanent) and log the actions into them accordingly.
6. Never invents steps or skip safety gates.
7. Escalate with clear lettered options (A/B/C/D) on any ambiguity.
8. Never run destructive git commands without explicit user approval. 

### Few-Shot Examples of the hotfix request (varied user phrasings the harness must handle)

**One-shot (minimal)**

```
Hotfix for Tata - TAT-101 - dns-resolution-fix using source branch hotfix/dhcp-scope-exhaustion
```

**One-shot (standard)**

```
Initialize a hotfix run for Tata. Ticket: TAT-101. Description: dns-resolution-fix. The source branch to consolidate is hotfix/dhcp-scope-exhaustion.
```

**Two-shot style**

```
Customer: Tata
Ticket: TAT-101
Description: dns-resolution-fix
Source branch: hotfix/dhcp-scope-exhaustion
Please run the consolidated hotfix workflow.
```

**Conversational / multi-shot**

```
We need a hotfix for the Tata tenant.
Ticket TAT-101, description dns-resolution-fix.
The fix is in branch hotfix/dhcp-scope-exhaustion.
Consolidate it and prepare the package.
```

**Other customers / variations**

```
Start consolidated hotfix for Vodafone. Ticket: VOD-142. Description: memory-leak-fix. Source branch: hotfix/duplicate-ip.
```

```
Create hotfix for Airtel. Ticket: AIR-089. Description: dhcp-timeout-improvement. Source branch: hotfix/airtel/dhcp-timeout-fix.
```

### Your Job as Harness / Orchestrator

- Read this file + the three agent files in `.hotfix-agents/`.
- Wait for a user command matching the style above.
- Begin by acknowledging the request, showing your plan, and executing step by step.
- Follow `AGENTS_chf.md` step-by-step (it will tell you exactly when to invoke the diffing and packaging agents).
- Maintain `CHF-STATE.md` and `HOTFIX-HISTORY.md`.
- Always escalate with lettered options (A/B/C/D) when the CHF agent tells you to.
- Never run destructive git commands without explicit user confirmation.

Start by reading `AGENTS_chf.md` completely, then wait for the first user hotfix request.

You are now ready to perform consolidated hotfixes for any tenant.

