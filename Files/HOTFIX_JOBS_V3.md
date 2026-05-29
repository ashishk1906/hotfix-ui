# Hotfix Jobs - Ticket Selection

This note covers how a hotfix job starts when tickets, branches, commits, and agents are involved.

## Main Decision

The agent can help find hotfix candidates, but the user should confirm before a hotfix job is created.

```txt
Agent recommends
User confirms
Backend creates hotfix job
Agents execute
```

This avoids accidental production-impacting work.

## Ticket Is Not Automatically A Hotfix

A ticket can be a normal bug, backlog item, production issue, release blocker, or hotfix candidate.

So we should not treat every ticket as a hotfix.

There must be a selection step before creating the hotfix job.

## How Tickets Are Picked

The user should be able to filter and select tickets.

Useful filters:

```txt
label = hotfix
label = release-blocker
label = production
priority = high / critical
status = open / in progress
affected release
affected service
linked PR exists
linked commit exists
updated recently
```

First version should start with:

```txt
Tickets labelled hotfix or release-blocker
```

## Agent-Assisted Selection

The agent can scan tickets and related GitHub data, then suggest candidates.

Signals the agent should check:

```txt
hotfix label
release-blocker label
critical priority
production incident link
affected release
linked PR
linked commits
CI failure link
comments asking for hotfix
```

The agent should return a ranked list with reasons.

Example:

```txt
JIRA-451 - Checkout 500 error
Reason: critical priority, hotfix label, linked PR #182
```

The user still decides whether to create the hotfix.

## Ticket And Commit Mapping

Sometimes the user already knows the ticket and commits.

Example:

```txt
Ticket: JIRA-451
Commits: abc123, def456
Target branch: release/2026.05
```

If commits are not provided, the agent can suggest likely commits using:

```txt
linked PRs
issue key in commit messages
branch names containing issue key
PR title/body mentioning the ticket
recent commits by assignee
```

User should confirm the commits before execution.

## Trigger Paths

### User-Selected

```txt
User selects ticket
User selects branch / PR / commits
User clicks Create Hotfix
Backend creates job
Agents execute
```

This should be the first implementation.

### Agent-Suggested

```txt
Agent scans tickets and GitHub data
Agent suggests candidates
User reviews and confirms
Backend creates job
Agents execute
```

This can be added when there are many tickets and selection needs help.

## What Should Not Happen

Avoid this:

```txt
Agent triggers hotfix without confirmation
Agent starts cherry-pick based only on ticket text
Frontend calls GitHub/Jira directly
Ticket status is treated as hotfix job status
Every bug ticket becomes a hotfix
```

## Data Flow

Frontend should call our backend only.

```txt
Frontend -> Backend
Backend -> Jira/GitHub/CI only when needed
```

External tools are discovery sources.

After creation, the backend hotfix job record is the source of truth.

## UI For Ticket Selection

Before creating a hotfix, show:

```txt
Ticket ID
Title
Priority
Labels
Affected service
Affected release
Linked PR
Linked commits
Reason for recommendation
Last updated
```

Actions:

```txt
Create Hotfix
View Ticket
View PR
Select Commits
Change Target Branch
Reject Candidate
```

## Hotfix Creation Payload

When the user confirms, backend receives structured data.

```json
{
  "ticket_id": "JIRA-451",
  "source_branch": "main",
  "target_branch": "release/2026.05",
  "pull_request": 182,
  "commits": ["abc123", "def456"],
  "owner": "release-eng",
  "risk": "high"
}
```

Backend then creates the hotfix job.

## After Creation

Ticket selection is done once the hotfix job is created.

The job then follows normal hotfix statuses:

```txt
created
queued
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

Ticket status and hotfix job status should remain separate.

## Recommended Flow

```txt
1. Backend fetches candidate tickets.
2. User filters tickets or agent suggests candidates.
3. User selects ticket and confirms branch / PR / commits.
4. Backend creates hotfix job.
5. Agents execute the job.
6. Agents and CI/CD report status to backend.
7. UI reads hotfix job status from backend.
```

## First Implementation

Build first:

```txt
Ticket candidate list
Hotfix/release-blocker filters
Manual ticket selection
Linked PR/commit display
Structured Create Hotfix action
Backend hotfix job creation
Polling for job status
```

## Final Recommendation

Start with manual ticket selection using clear filters.

Then add agent-assisted recommendations.

Do not let the agent silently trigger a hotfix. The user should confirm ticket, branch, PR, commits, and owner before the backend creates the job.
