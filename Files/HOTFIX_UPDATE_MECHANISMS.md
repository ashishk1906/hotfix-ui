# Hotfix Job Status Update Mechanism

Current focus is **hotfix jobs**, not the dashboard.

We should choose one status update mechanism for hotfix jobs before implementation and stick with it. Switching later can take time because it affects backend job APIs, frontend consumption, testing, and deployment behavior.

The backend remains the source of truth for every hotfix job. The UI is only one consumer of that job status.

## Questions We Need To Answer

```txt
How will consumers know a hotfix job status changed?
How many HTTP calls will this create?
What load will it add to the server?
How complex is it to implement now?
Will it still work when real CI/CD updates are added?
```

## Option 1: Polling

Consumers call the backend at a fixed interval, for example every 5 seconds.

Flow:

```txt
Consumer calls GET /api/v1/hotfixes
Backend returns latest job statuses
Consumer updates its view
Wait 5 seconds
Repeat
```

HTTP calls:

```txt
1 browser tab = 1 request every 5 seconds
1 user = 12 requests per minute
10 users = 120 requests per minute
100 users = 1,200 requests per minute
```

Server load:

```txt
Low if the endpoint reads from our database/cache.
High only if the endpoint calls GitHub/Jira/CI every time.
```

Important rule:

```txt
GET /api/v1/hotfixes should read from our backend DB/cache only.
Do not call GitHub, Jira, or CI tools on every poll.
```

Implementation effort:

```txt
Low.
Normal REST endpoint + frontend timer.
```

This is the simplest practical option.

## Option 2: Manual Refresh

The UI updates only when the user clicks refresh.

Flow:

```txt
User clicks Refresh
UI calls GET /api/v1/hotfixes
Backend returns latest statuses
UI renders table
```

HTTP calls:

```txt
Only when the user clicks refresh.
Very low server load.
```

Implementation effort:

```txt
Very low.
```

Problem:

```txt
The UI can stay stale.
User may miss running -> completed changes.
```

This is not enough for hotfix job tracking as the main mechanism.

## Option 3: Long Polling

The consumer sends a request and the backend keeps it open until something changes or the request times out.

Flow:

```txt
Consumer calls GET /api/v1/hotfixes/updates
Backend waits for a change
Backend responds when status changes or timeout happens
Consumer updates its view
Consumer starts another request
```

HTTP calls:

```txt
Fewer completed responses than polling when nothing changes.
Still keeps one open request per active browser tab.
```

Server load:

```txt
Medium.
Backend must hold open connections.
Needs timeout and retry handling.
```

Implementation effort:

```txt
Medium.
More complex than polling.
```

This is possible, but probably more complexity than we need for the first version.

## Option 4: Server-Sent Events

The browser opens one live connection. The backend pushes hotfix job status updates to the consumer.

Flow:

```txt
Consumer opens event stream
Backend sends event when hotfix status changes
Consumer updates the affected job
```

HTTP calls:

```txt
1 long-lived connection per active browser tab.
No repeated polling calls.
```

Server load:

```txt
Good for status updates and logs.
Backend must support streaming connections.
```

Implementation effort:

```txt
Medium.
Need event stream endpoint and reconnect handling.
```

This is a strong option if we want near real-time updates without WebSocket complexity.

## Option 5: WebSockets

The browser opens a live two-way connection with the backend.

Flow:

```txt
Consumer connects to WebSocket
Backend pushes status changes
Consumer can also send commands through the same connection
```

HTTP calls:

```txt
1 persistent WebSocket connection per active browser tab.
No repeated polling calls.
```

Server load:

```txt
Works well for real-time systems.
More operational complexity than REST polling or SSE.
```

Implementation effort:

```txt
High compared to the current project.
Need connection handling, reconnect logic, and scaling plan.
```

This is only worth it if the dashboard needs live two-way control, not just status display.

## Webhooks Are Separate

Webhooks are how external systems update our backend job status. They do not directly update the UI.

Flow:

```txt
CI/CD job completes
CI/CD calls POST /webhooks/hotfix-status
Backend updates hotfix status in DB
Consumers read updated status using the selected mechanism
```

We still need one consumer update mechanism:

```txt
Polling, Long Polling, SSE, or WebSockets
```

## Best Choice For Hotfix Jobs

Recommended mechanism:

```txt
Polling every 5 seconds
```

Why:

```txt
It is simple.
It works with normal REST APIs.
It is easy to test.
It is enough for hotfix job status tracking.
Server load is acceptable if the backend reads from DB/cache.
It does not require streaming or socket infrastructure.
```

Expected load:

```txt
100 active users at 5-second polling = about 1,200 requests per minute.
This is fine for a lightweight backend endpoint reading from DB/cache.
```

Important backend rule:

```txt
Polling endpoint must not call GitHub/Jira/CI every time.
External data should be fetched during job creation, webhook update, or background refresh.
The job list/detail endpoints should return stored backend data.
```

Final decision:

```txt
Use polling for the first hotfix job implementation.
Add CI/CD webhooks to update backend status.
Only choose SSE instead if we need near real-time live logs/status from day one.
Avoid WebSockets unless we need two-way real-time controls.
```
