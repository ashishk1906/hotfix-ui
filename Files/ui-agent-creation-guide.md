# UI Agent Creation Guide For Hotfix Jobs

## Purpose

This guide is for creating a simple UI agent for Hotfix / CHF Jobs.

The first version should focus only on managing jobs.

The UI should help a release engineer create a hotfix job, track its current state, handle blockers, and close it.

## Main Idea

The main object in the UI is a **Job**.

A Job represents one HotFix or CHF request.

Example:

```txt
Ticket: TAT-101
Customer: Tata
Issue: dns-resolution-fix
Type: CHF
Baseline: release/tata/1.0
Source branch: hotfix/dhcp-scope-exhaustion
Status: Running
```

The UI should answer these basic questions:

```txt
What is the issue?
Who is affected?
Which version or branch is affected?
Is this a HotFix or CHF?
What stage is it in?
Is it blocked?
Who owns it?
```

## Screens Needed

For the first version, only these screens are needed:

```txt
Jobs List
Create Job
Job Details
Blocker / Decision View
```

No separate dashboard is needed.

## Jobs List

The Jobs List should be the main screen.

It should show the important job columns from the Hotfix Jobs file.

Recommended columns:

```txt
Job ID
Ticket ID
Customer / Tenant
Issue summary
Job type
Severity
Status
Current stage
Owner
Updated at
Blocker reason
```

Useful filters:

```txt
Customer / Tenant
Status
Job type
Severity
Owner
```

The list should be simple and easy to scan.

## Create Job

The Create Job form should collect only what is needed to start the job.

Required fields:

```txt
Ticket ID
Customer / Tenant
Issue summary
Description
Severity
Job type
Affected baseline
Source branch or commit
Owner
```

Optional fields:

```txt
Jira link
Customer report link
Notes
```

The UI should not allow the job to be created if required fields are missing.

## Job Type

The UI should support:

```txt
HotFix
CHF
```

Use **HotFix** when one specific fix is needed.

Use **CHF** when multiple approved fixes need to be combined for the same tenant or release.

The UI should not automatically include fixes. The user should clearly select or provide the source branch/commit.

## Job Status

Use simple statuses:

```txt
Created
Running
Blocked
Completed
Closed
Failed
```

If a job is blocked, show the reason clearly.

Examples:

```txt
Source branch not found
Baseline not confirmed
Cherry-pick conflict
Test failed
Push approval required
```

## Job Stages

Use simple stages:

```txt
Created
Baseline Selected
Fix Selected
Branch Created
Fix Applied
Testing
Merge And Tag
Push
Deployment
Closed
```

For CHF jobs, `Fix Selected` can mean one or more approved fixes.

Only show actions that make sense for the current stage.

## Job Details

The Job Details page should show the full state of one job.

Show:

```txt
Ticket ID
Customer / Tenant
Issue summary
Description
Severity
Job type
Owner
Status
Current stage
Affected baseline
Source branch or commit
Hotfix / CHF branch
Target branch
Tag
Blocker reason
Last updated
Timeline
```

This page should be readable without opening logs.

## Baseline

The baseline should be clear because hotfix work should start from the affected tenant or release version.

Example:

```txt
Affected baseline: release/tata/1.0
```

Do not assume latest `main` is the baseline.

If the baseline is missing, the job should be blocked.

## Timeline

Each job should have a simple timeline.

Example:

```txt
Job created
Baseline selected
Branch created
Fix applied
Testing completed
Merged and tagged
Pushed
Deployed
Closed
```

The timeline should show what happened and when.

## Blockers And Decisions

If a job is blocked, the UI should show:

```txt
What is blocked
Why it is blocked
What options are available
```

Example:

```txt
Problem: Source branch not found.

A. Wait for the correct source branch
B. Use another approved source branch
C. Stop this job
```

Avoid vague messages like:

```txt
Something went wrong
```

## Actions

Possible actions:

```txt
Create job
Select baseline
Add source branch or commit
Create branch
Mark fix applied
Mark testing completed
Mark merged and tagged
Mark pushed
Mark deployed
Close job
```

Actions should be shown based on the current job stage.

## What To Avoid

Do not include these in the first version:

```txt
Dashboard
Charts
Analytics
Artifact viewer
Packaging screen
Large reports
Decorative cards
Extra admin pages
```

Keep the UI practical and job-focused.

## Final Direction

The first version should be a simple Jobs UI.

Flow:

```txt
Create Job
Track Job
Handle Blockers
Update Stage
Close Job
```

The UI should be clean, simple, and useful for release engineers managing HotFix and CHF jobs.
