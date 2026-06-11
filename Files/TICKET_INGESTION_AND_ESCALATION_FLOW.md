# Ticket Intake And Escalation

This is the first step after a production issue is reported.

Usually the customer will not give a perfect technical ticket. They may only say something like:

```txt
I am unable to login to the Airtel portal.
It says "Invalid credentials", but my password is correct.
This is urgent because our team cannot access the system.
```

Our job is to turn this into a useful ticket.

The goal is simple:

```txt
Understand the issue.
Find the missing details.
Add customer and system information.
Decide priority.
Try basic checks.
Escalate with enough context if needed.
```

## What We Should Capture First

When the ticket comes in, save the original message as it is.

Then capture the basic details:

```txt
Ticket ID
Customer or tenant name
Who reported it
Issue summary
Exact error message
Affected environment
Screenshots or logs, if available
How many users are affected
When the issue started
```

For the Airtel login example, we can already understand:

```txt
Customer: Airtel
Issue: Unable to login
Error: Invalid credentials
Impact: Team cannot access the system
Screenshot: Not available
Priority signal: Urgent / access blocked
```

But some important details are still missing.

## Ask Only What Is Missing

Support should not ask too many questions.

Ask only the details that are needed and not already available internally.

Example reply:

```txt
Thank you for reaching out.

We have received your ticket and are checking it.

Could you please confirm:
1. Is this happening in Production or Staging?
2. How many users are affected?
3. When did this start?
4. Can you share a screenshot or exact error text if possible?

We will update you shortly.
```

If tenant ID, deployed version, or customer tier can be found from internal systems, support should fetch it themselves.

## Add Internal Details

After the ticket is created, enrich it with internal information.

For a first version, these details are enough:

```txt
Tenant ID
Customer tier
Environment
Current running branch
Deployed version
Last deployment time
Recent known incidents
```

Example internal note:

```txt
Customer: Airtel
Tenant ID: airtel-prod-001
Customer tier: Enterprise
Environment: Production
Running branch: release/v2.3.4
Deployed version: v2.3.4
Issue: Login failure
Error: Invalid credentials
Priority: High
Reason: Enterprise customer + production login blocked
```

This note helps L1, L2, and engineering see the same picture.

## Decide Priority

Priority should come from impact, not just from the word "urgent".

Mark it high priority when:

```txt
Production is affected
Login or core workflow is blocked
Many users are affected
Enterprise or important customer is affected
No workaround is available
Issue started after recent deployment
```

For the Airtel login issue, high priority makes sense because production access may be blocked.

## L1 Support Checks

L1 should do simple checks before escalating.

For a login issue, check:

```txt
Is the portal up?
Is this only one user or all users?
Is the account locked or disabled?
Was the password recently changed?
Is there any active incident?
Was there a recent deployment?
Are there obvious login errors in logs?
```

Basic actions:

```txt
Ask user to retry
Suggest password reset
Try another browser or incognito
Check tenant status
Check account status
Check service health
```

If this fixes the issue, update the customer and close after confirmation.

If it does not fix the issue, escalate to L2.

## When To Escalate To L2

Escalate when L1 cannot solve it and the issue looks technical.

Examples:

```txt
Backend logs show errors
Multiple users are affected
Production login is blocked
Tenant configuration may be wrong
Authentication service needs checking
Database or backend state needs checking
```

Before escalating, the ticket should contain:

```txt
Ticket ID
Tenant ID
Environment
Running branch or version
Error message
Customer impact
What L1 already checked
What is still missing
```

This is important because L2 should not have to restart from zero.

## Tell The Customer

When escalating, update the customer in simple language.

Example:

```txt
Thank you for your patience.

We have escalated this to our Level 2 technical team for deeper investigation.
They will check the authentication logs and tenant configuration.

The ticket remains open and high priority.
```

## What L2 Should Check

L2 uses the enriched ticket and starts deeper debugging.

For a login issue, L2 should check:

```txt
Tenant logs
Authentication logs
Failed login attempts
User account status
Tenant configuration
Recent deployments
Recent commits on the running branch
Login API error rate
Login API latency
```

Possible workarounds:

```txt
Clear user session
Force password reset
Clear tenant auth cache
Check SSO / OAuth / LDAP provider
Test another user from the same tenant
```

If a workaround works, update the customer.

If it needs a code change, escalate to engineering with the full details.

## Simple Flow

```txt
Customer reports issue
Ticket is created
Raw message is saved
Important details are extracted
Missing details are asked
Internal tenant details are added
Priority is decided
L1 does basic checks
If resolved, update customer
If not resolved, escalate to L2
L2 checks logs and backend
If workaround exists, apply it
If code change is needed, escalate to engineering
```

## What Must Be Logged

Keep a clear history of:

```txt
Original customer message
Details extracted from ticket
Internal details added
Questions asked to customer
Priority decision and reason
L1 checks done
Escalation reason
Customer updates
```

## Final Understanding

Ticket intake is not about writing a big document.

It is about making a vague issue clear enough for the next person to act.

For the first version, the important rule is:

```txt
Do not escalate an empty ticket.
Add enough context so L2 or engineering can start directly.
```
