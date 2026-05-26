# Hotfix Jobs

The goal is to define who uses hotfix jobs, what they need from the workflow, what data should be captured, and how job status should be updated.

## Problem We Are Solving

In real life, a hotfix is created when a production or release-blocking issue needs to be fixed quickly and safely.

The system should help teams:

```txt
Create a hotfix job
Track where the job is in the workflow
Know who owns it
Know what branch/release it affects
Know whether it completed, failed, or needs attention
```

The important object is the **hotfix job**.

## Primary Users

### Release Engineer

Most important persona.

They care about:

```txt
Which hotfixes are active
Which release branch is affected
Whether validation/build/deploy is blocked
Who owns approval
Whether the job completed safely
```

They need clear status and failure visibility.

### DevOps / SRE

They care about operational execution.

They need:

```txt
Job status
Build/deploy result
Failure reason
Logs or link to logs
Retry/cancel possibility
```

They do not need constant UI movement unless something is failing or blocked.

### Developer

They usually provide or validate the code fix, but they should not be assumed as the primary person executing the hotfix workflow.

They need:

```txt
Issue being fixed
Source branch
Hotfix branch
Commit/cherry-pick status
Validation result
```

They mostly need to know whether their fix moved forward or failed.

### Engineering Manager / Project Manager

They care about outcome and risk.

They need:

```txt
Which hotfix is in progress
Current status
Risk level
Owner
ETA or last update
Completed/failed state
```

They do not need high-frequency technical updates.

## Who Owns The Hotfix Execution

In a controlled release process, the hotfix job should usually be executed by:

```txt
Release engineer
SRE / DevOps engineer
```

Developers may still be involved, but mostly as contributors or requesters.

Developer role:

```txt
Provide the fix
Confirm the issue
Help resolve validation failures
Review the final change if required
```

Support or product teams may raise the issue, but they should not own hotfix execution.

Support/Product role:

```txt
Report production issue
Provide impact/severity
Confirm customer/business priority
```

The system should not assume the person who raises the issue is the person who executes the hotfix.

Recommended ownership model:

```txt
Requester: person who created/requested the hotfix
Owner: person/team responsible for executing it
Approver: person/team responsible for approving release
```

For the current table, we only show `Owner`.

Requester and Approver can be added later if the workflow needs them.

## Real-Life Hotfix Scenario

Example:

```txt
1. Production issue is found.
2. Issue/ticket is created or linked.
3. A hotfix job is created.
4. Backend generates hotfix ID and branch.
5. Fix commits are cherry-picked or merged.
6. Build/validation runs.
7. Approval may be required.
8. Hotfix is deployed or merged to target branch.
9. Job ends as completed or failed.
```

The hotfix job should capture enough information to answer:

```txt
What is being fixed?
Where is the fix going?
Who owns it?
What state is it in?
What changed recently?
Does someone need to act?
```

## Current Hotfix Job Fields

These are the fields currently useful for the hotfix job list.

| Field | Meaning |
|---|---|
| **ID** | Unique hotfix job ID, for example `CHF-401`. |
| **Issue** | Short description or linked issue summary. |
| **Branch** | Hotfix branch, for example `hotfix/CHF-401`. |
| **Base** | Release/source branch, for example `release/2026.05`. |
| **Status** | Hotfix job status, not Jira/GitHub ticket status. |
| **Risk** | Risk level such as `high`, `medium`, or `low`. |
| **Owner** | Person/team responsible for this hotfix job. |
| **Updated** | Last time the hotfix job changed. |

## Meaning Of Status

`Status` means **hotfix job status**.

It does not mean Jira/GitHub issue status like `open`, `closed`, or `resolved`.

Recommended hotfix job statuses:

```txt
created
cherry_picking
building
validating
waiting_approval
deploying
completed
failed
cancelled
```

If ticket status is needed later, it should be a separate field called:

```txt
Issue Status
```

Do not mix issue status with hotfix job status.

## What Should Be Surfaced

For hotfix jobs, surface only data that helps users understand action and state.

Must have:

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

Useful later:

```txt
Failure reason
Validation result
Build/deploy link
Logs link
Approver
Requester
Last event
```

Avoid adding fields just because they are available from GitHub/Jira.

## Source Of Truth

Backend is the source of truth.

Frontend should not call GitHub, Jira, or CI/CD directly.

Correct flow:

```txt
Frontend -> Backend
Backend -> Database
Backend -> GitHub/Jira/CI/CD only when needed
```

Why:

```txt
Secrets/tokens stay out of the browser
Backend can cache external data
Backend controls rate limits
Frontend stays simple
Job status stays consistent
```

External data such as branch, base, issue title, commits, and reviews should be fetched by backend and stored/cached in the job record.

## Do We Need Real-Time Updates?

For hotfix jobs, real-time updates are not the first requirement unless users need live logs or instant deployment progress.

Most personas need:

```txt
Current status
Failure/blocker visibility
Recent update time
Clear ownership
```

They usually do not need millisecond-level updates.

So the system should focus first on reliable job state, not live UI streaming.

## Update Mechanism Decision

Because we do not want to switch mechanisms later, we should choose one simple mechanism that fits hotfix jobs.

Recommended mechanism:

```txt
Polling
```

Expected flow:

```txt
1. Backend stores hotfix job status.
2. CI/CD or backend workflow updates status.
3. Frontend calls GET /api/v1/hotfixes periodically.
4. Backend returns latest stored job data.
5. Frontend displays the latest status.
```

Example:

```txt
Job status is building
CI/CD completes validation
Backend updates status to waiting_approval
Frontend fetches latest jobs
Frontend shows waiting_approval
```

## Why Polling Is Enough

Polling is enough for the first hotfix job implementation because:

```txt
Hotfix job state does not need instant UI updates
Users mainly need reliable current state
REST APIs are simple to build and test
No streaming/socket infrastructure is required
Server load is acceptable if backend reads from DB/cache
```

Suggested interval:

```txt
5 to 10 seconds
```

Load example:

```txt
1 user at 5 seconds = 12 requests/minute
10 users = 120 requests/minute
100 users = 1,200 requests/minute
```

This is acceptable for a lightweight endpoint that reads from backend DB/cache.

Important:

```txt
Polling endpoint must not call GitHub/Jira/CI every time.
It should return stored backend data.
```

## What About WebSockets Or SSE?

Do not start with WebSockets.

WebSockets are useful only if users need two-way real-time control, such as:

```txt
live command execution
interactive deployment controls
real-time collaboration
```

SSE can be considered later if we need:

```txt
live logs
near real-time job events
push-only backend updates
```

For the current hotfix job focus, polling is the better first choice.

## Role Of Webhooks

Webhooks are still useful, but they are backend-side.

Example:

```txt
CI/CD job finishes
CI/CD calls backend webhook
Backend updates hotfix job status in DB
Frontend reads latest status through polling
```

Webhooks update the backend.

Polling lets users see the updated backend state.

## Recommended Backend APIs

Minimum APIs:

```http
POST /api/v1/hotfixes
GET  /api/v1/hotfixes
GET  /api/v1/hotfixes/{id}
GET  /api/v1/hotfixes/{id}/logs
```

Webhook API later:

```http
POST /api/v1/webhooks/hotfix-status
```

## First Implementation Scope

Build hotfix jobs first.

Include:

```txt
Create hotfix job
Store job record
Generate ID and branch
Store issue, base, risk, owner
Track hotfix job status
Track updated_at
Expose list/detail APIs
Support polling from frontend
```

Do not start with:

```txt
WebSockets
Complex dashboards
Direct frontend GitHub calls
Direct frontend Jira calls
Too many columns
Live logs unless explicitly required
```

## Final Recommendation

Implement the hotfix job system like this:

```txt
Hotfix jobs are the core object.
Backend owns all job data and status.
Frontend reads only from backend APIs.
Polling is the selected update mechanism.
CI/CD webhooks update backend job status.
SSE/WebSockets are not needed unless live logs or instant updates become a hard requirement.
```
