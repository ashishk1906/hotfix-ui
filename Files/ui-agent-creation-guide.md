# UI Agent Creation Guide For Hotfix Jobs

## Purpose

This guide is for creating the UI agent for Hotfix / CHF Jobs.

The UI should focus only on **Jobs**.

The main purpose of the UI is to help the release engineer manage hotfix jobs from creation to closure.

## Source Of Truth

The UI agent must use the Hotfix Jobs file as the source of truth for fields and columns.

If the Hotfix Jobs file has a column, the UI should respect it.

If a field is not part of the Hotfix Jobs flow, do not add it unless it is required for job execution.

The UI should be built around the job record, not around a generic dashboard.

## What A Job Represents

A Job represents one HotFix or CHF request.

Example:

```txt
Ticket: TAT-101
Customer: Tata
Description: dns-resolution-fix
Type: CHF
Baseline: release/tata/1.0
Source branch: hotfix/dhcp-scope-exhaustion
Status: Closed
```

The Job should show:

```txt
what issue is being fixed
which tenant or release is affected
which baseline is used
which fixes are included
what stage the job is in
whether the job is blocked
which artifacts were generated
whether the job was merged, tagged, pushed, deployed, and closed
```

## Main Screens

The first version should have only these screens:

```txt
Jobs List
Create Job
Job Details
Decision / Blocker View
```

Do not create a separate dashboard for the first version.

Do not create a separate Artifact View in the first version. Artifacts should be shown inside the Job Details page.

## Jobs List

The Jobs List is the main screen.

It should show the job columns from the Hotfix Jobs file.

Recommended columns:

```txt
Job ID
Ticket ID
Customer / Tenant
Issue summary
Severity
Job type
Status
Current stage
Affected baseline
Source branch
CHF branch
Release / tenant branch
Tag
Package status
Owner
Created at
Updated at
Blocker reason
```

The table should be simple and operational.

The user should quickly understand:

```txt
which jobs are running
which jobs are blocked
which jobs are waiting for approval
which jobs are completed
which jobs are closed
```

Useful filters:

```txt
Customer / Tenant
Status
Current stage
Job type
Severity
Owner
Created date
Updated date
```

## Create Job

The Create Job form should collect only the fields required to start the hotfix workflow.

Required fields:

```txt
Ticket ID
Customer / Tenant
Issue summary
Description
Severity
Job type
Affected baseline
Source branch or source commits
Owner
```

Optional fields:

```txt
Jira link
Customer report link
Steps to reproduce
Environment
Notes
Deployment notes
Rollback notes
```

The UI should not allow job creation if required fields are missing.

## Job Type

The UI should support two job types:

```txt
HotFix
CHF
```

Use **HotFix** when only one specific fix needs to be shipped.

Use **CHF** when multiple approved fixes need to be shipped together for the same tenant or release version.

The UI should not automatically include every available fix. The selected fixes must be explicit.

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

If the job is blocked, show the exact reason.

Examples:

```txt
Source branch not found
Baseline not confirmed
Cherry-pick conflict
Unexpected files in diff
Test failed
Packaging failed
Evaluator approval required
Push approval required
```

## Job Stages

The job should move through clear stages:

```txt
Created
Baseline Identified
Fixes Selected
Branch Created
Fixes Applied
Testing
Diff Review
Packaging
Merge And Tag
Push
Deployment
Carry Forward
Closed
```

Only one current stage should be active at a time.

The UI should show actions based on the current stage only.

## Job Details Page

The Job Details page is the most important page.

It should show:

```txt
Job summary
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
Source branch
Source commits
CHF branch
Release / tenant branch
Tag
Package artifact
Test result
Diff result
Blocker reason
Timeline
Artifacts
```

The user should understand the job state without reading raw logs first.

## Baseline Section

The baseline must be shown clearly.

Example:

```txt
Baseline branch: release/tata/1.0
Baseline commit: bc58516
```

This is important because CHF should start from the affected tenant or release baseline.

It should not start from latest `main` by default.

If the baseline is missing or unclear, the job should become blocked.

## Fixes Section

For CHF jobs, show the selected fixes.

Each selected fix should show:

```txt
Commit hash
Source branch
Linked ticket
Short description
Approval status
Included / excluded
Reason
```

If a commit has unrelated changes, the UI should show that review is required.

## Diff Review

The UI should show the effective diff between the baseline and the hotfix branch.

Show:

```txt
Changed files
Added files
Removed files
Generated files
Excluded files
Risk notes
```

If the diff contains unexpected files, the job should be blocked until reviewed.

## Testing

The UI should show test information clearly.

Show:

```txt
Test command
Exit code
Result
Last output lines
Smoke test result
Known limitation
```

If tests fail, the UI should show whether the failure is:

```txt
new
pre-existing
unclear
```

Do not hide failed tests.

## Packaging

The Packaging section should show what will be deployed.

Show:

```txt
Package name
Package version
Included files
Rollback files
Install script
Rollback script
Manifest
Checksum file
Archive file
Validation result
```

The package should include only:

```txt
approved changed files
rollback files
install script
rollback script
manifest
checksums
```

Do not package unrelated files.

## Decisions And Blockers

If the job needs a human decision, show the problem and clear options.

Example:

```txt
Problem: Source branch not found.

A. Stop and wait for the correct source branch
B. Use another approved source branch
C. Create a simulated branch for demo only
```

Avoid vague messages like:

```txt
Something went wrong
```

The UI should always show the reason.

## Timeline

Each job should have a readable timeline.

Example:

```txt
Job created
Baseline selected
Source commit inspected
CHF branch created
Fix cherry-picked
Tests executed
Diff reviewed
Package generated
Release branch merged
Tag created
Branch pushed
Deployment completed
Fix carried forward
Job closed
```

The timeline should be understandable for engineering, QA, and management.

## Artifacts

The job should show generated artifacts inside the Job Details page.

A separate Artifact View is not needed for the first version.

Examples:

```txt
Diff manifest
Packaging manifest
Evaluator report
Install script
Rollback script
Checksum file
Package zip
Hotfix history entry
```

Each artifact should show:

```txt
Name
Type
Path
Created time
Status
```

## Valid Actions

Actions should depend on the current job stage.

Possible actions:

```txt
Create job
Select baseline
Add fix commit
Create hotfix branch
Run tests
Run diff review
Generate package
Mark evaluator passed
Create tag
Push branch and tag
Mark deployed
Carry forward to main
Close job
```

Do not show actions that are not valid for the current stage.

## What To Avoid

Avoid:

```txt
Dashboard-first design
Large charts
Analytics widgets
Marketing-style screens
Decorative cards
Generic admin pages
Unrelated settings pages
Unnecessary explanations
Fake metrics
```

The UI should be practical and job-focused.

## Simple Job Shape

Use the actual Hotfix Jobs columns as the final source of truth.

This is only an example structure:

```json
{
  "job_id": "JOB-001",
  "ticket_id": "TAT-101",
  "customer": "Tata",
  "issue_summary": "dns-resolution-fix",
  "severity": "High",
  "job_type": "CHF",
  "status": "Closed",
  "current_stage": "Closed",
  "affected_baseline": "release/tata/1.0",
  "source_branch": "hotfix/dhcp-scope-exhaustion",
  "source_commits": ["125e8cf"],
  "chf_branch": "chf/TAT-101-dns-resolution-fix",
  "release_branch": "release/tata/1.0",
  "tag": "v1.0.0-tata-hf1",
  "package_artifact": "bitloka-hotfix-demo-TAT-101.zip",
  "owner": "release-engineer",
  "blocker_reason": null,
  "artifacts": [],
  "timeline": []
}
```

## Final Direction

The UI agent should build a Jobs-first interface.

The flow should be:

```txt
Create Job
Select Baseline
Select Fixes
Create Branch
Apply Fixes
Test
Review Diff
Package
Merge And Tag
Push
Deploy
Carry Forward If Needed
Close Job
```

The UI should help the release engineer manage hotfix jobs safely and clearly.

No dashboard noise is needed.
