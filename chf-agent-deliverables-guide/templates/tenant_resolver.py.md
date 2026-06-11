# Template - tenant_resolver.py

Generate this file as:

```txt
deliverables/scripts/tenant_resolver.py
```

## Purpose

Resolve tenant metadata when available.

For local testing, this can read from a JSON fixture.

## Responsibilities

```txt
resolve tenant name
return tenant ID if available
return running branch/tag/commit if available
return deployed version if available
return customer tier if available
```

## Suggested CLI

```txt
python tenant_resolver.py resolve --tenant Tata --data examples/tenants.json
```

## Output Shape

```json
{
  "ok": true,
  "tenant_name": "Tata",
  "tenant_id": "tata-prod-001",
  "baseline_ref": "release/tata/1.0",
  "deployed_version": "v1.0.0",
  "customer_tier": "Enterprise"
}
```

## Rules

```txt
Do not invent tenant metadata.
If metadata is missing, return null fields clearly.
```

