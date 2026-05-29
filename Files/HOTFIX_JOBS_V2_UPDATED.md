# Hotfix Jobs V2

This note is focused on **hotfix jobs**, not dashboards.

The goal is to define how a hotfix job is requested, executed, tracked, and handled when it needs user input.

## Scope

A hotfix job represents one controlled workflow to fix a production or release-blocking issue.

The job should answer:

```txt
What is being fixed?
Who requested it?
Who owns execution?
Which branch/release is affected?
What is the current state?
Is anything blocked?
What action is needed next?
```

## Personas

| Persona | Interest |
|---|---|
| Support / Escalation owner | Reports the production impact and requests the fix. |
| Product / Project manager | Confirms priority, urgency, and business impact. |
| Developer | Provides or validates the code fix. Helps with conflicts or failed tests. |
| Release Engineer | Owns the hotfix execution flow in most cases. |
| DevOps / SRE | Handles build, deploy, rollback, and pipeline issues. |
| Approver | Approves release/deployment when policy requires it. |

Important:

```txt
Requester is not always the executor.
Developer is not always the executor.
Release Engineering / DevOps / SRE should usually own execution.
```

Recommended ownership fields:

```txt
requester
owner
approver
```

## How A Hotfix Is Triggered

The first version should use a **structured UI trigger**.

The user should select or enter:

```txt
Issue / ticket
Source or base branch
Target release branch
Fix branch or PR
Risk / severity
Owner
Approver, if required
```

Then the user clicks:

```txt
Create Hotfix
```

Why structured input first:

```txt
Clear inputs
Better validation
Less ambiguity
Easier audit trail
Safer for production workflows
```

## Expected Job Flow

```txt
1. User selects issue, branch, owner, and required inputs.
2. Backend creates the hotfix job.
3. Backend generates hotfix ID and branch if needed.
4. Agent/workflow starts execution.
5. Steps report events back to backend.
6. Backend stores current status and latest event.
7. User acts if the job is blocked.
8. Job ends as completed, failed, or cancelled.
```

## Status Source

The backend should be the source of truth.

Status should come from backend-side workflow events, not from the frontend.

Possible status sources:

```txt
Job orchestrator
Agent execution state
CI/CD webhook
Git operation result
Approval workflow
Deployment result
```

Example:

```txt
Cherry-pick agent reports conflict_detected
Backend stores status = waiting_user_input
Backend stores blocker_type = merge_conflict
Frontend reads the latest state from backend
```

## Job Statuses

Recommended statuses:

```txt
created
queued
running
cherry_picking
building
validating
waiting_approval
waiting_user_input
deploying
completed
failed
cancelled
```

`Status` means hotfix job status.

It should not be confused with Jira/GitHub ticket status like `open`, `closed`, or `resolved`.

If ticket status is needed later, it should be a separate field called `Issue Status`.

## Handling Blocked Jobs

Agents may stop when user input is required.

Common blockers:

```txt
Merge conflict
Cherry-pick failure
Build failure
Test failure
Missing approval
Invalid branch
Invalid ticket
High risk requiring approval
Deployment failure
```

When blocked, backend should store:

```txt
status
blocker_type
blocker_message
required_action
assigned_to
updated_at
```

Example:

```json
{
  "status": "waiting_user_input",
  "blocker_type": "merge_conflict",
  "blocker_message": "Cherry-pick failed due to conflict in payment_service.py",
  "required_action": "Resolve conflict and mark as resolved",
  "assigned_to": "developer"
}
```

## User Interaction When Blocked

Known workflow decisions should be handled through explicit UI actions.

Examples:

```txt
Mark Conflict Resolved
Retry Build
Retry Tests
Approve Hotfix
Reject Hotfix
Cancel Job
Continue Deployment
Assign Owner
```

These actions should call backend APIs and be stored as job events.

## Risk

Risk should be calculated or stored by the backend.

Inputs for risk can include:

```txt
Commit count
Files changed
Critical service area
Issue severity
Validation result
Deployment target
Manual override
```

Recommended values:

```txt
low
medium
high
critical
```

If risk is `high` or `critical`, the backend can move the job to:

```txt
waiting_approval
```

## What Should Surface In UI

Minimum list view:

```txt
ID
Issue
Branch
Base
Status
Risk
Owner
Updated
```

Job detail view should show:

```txt
Current status
Latest event
Blocker reason
Required action
Owner
Approver
Logs or logs link
Build/test/deploy links
Event timeline
```

For blocked jobs, the UI should clearly show:

```txt
What stopped
Who needs to act
What action is expected
Which action button is available
```

## Update Mechanism

Use polling for the first implementation.

Flow:

```txt
Backend stores current job state
Agents/CI/CD update backend state
Frontend calls GET /api/v1/hotfixes every 5-10 seconds
Frontend displays latest stored state
```

Important:

```txt
Polling endpoint should read from backend DB/cache.
It should not call GitHub, Jira, or CI/CD every time.
```

WebSockets are not needed unless we need two-way real-time control.

SSE can be considered later if live logs or near real-time event streaming becomes a hard requirement.

## Webhooks And Agent Events

External systems and agents should report status to the backend.

Examples:

```txt
CI/CD -> backend: build_completed
Cherry-pick agent -> backend: conflict_detected
Build agent -> backend: build_failed
Approval flow -> backend: approved
Deploy agent -> backend: deployment_completed
```

Backend stores these events and derives the current job status.

## Recommended APIs

```http
POST /api/v1/hotfixes
GET  /api/v1/hotfixes
GET  /api/v1/hotfixes/{id}
GET  /api/v1/hotfixes/{id}/events
GET  /api/v1/hotfixes/{id}/logs
POST /api/v1/hotfixes/{id}/actions
POST /api/v1/hotfixes/{id}/events
POST /api/v1/webhooks/hotfix-status
```

Example user action:

```json
{
  "action": "mark_conflict_resolved",
  "comment": "Conflict resolved in payment_service.py"
}
```

Example agent event:

```json
{
  "event_type": "build_failed",
  "message": "Unit tests failed in checkout module",
  "source": "build_agent"
}
```

## First Implementation

Build first:

```txt
Structured hotfix creation
Job record persistence
Hotfix ID and branch generation
Status tracking
Risk tracking
Owner tracking
Blocker and required action tracking
List/detail APIs
User action API
Basic agent/event reporting
Polling-based status refresh
```

Do not start with:

```txt
WebSockets
Complex dashboard views
Live logs unless required
Direct frontend GitHub calls
Direct frontend Jira calls
```

## Final Recommendation

Design the hotfix job system around this flow:

```txt
User triggers hotfix from structured UI
Backend creates job
Agents execute workflow
Agents report status/events to backend
Backend stores current state and blockers
User responds through explicit UI actions when blocked
Frontend polls backend for latest state
```

This keeps the workflow clear, auditable, and realistic for production hotfix execution.
