# AGENTS.md

## Purpose

`gepa_buildout` owns deterministic domain task examples and fixtures layered
over `/home/home/p/g/n/gepa_framework`.

## Boundaries

- Own domain task descriptors, example datasets, evaluator descriptors, and
  package-local proof helpers.
- Do not own GEPA optimizer internals, governed platform orchestration,
  provider credentials, product UX, durable defaults, dynamic atom creation,
  ambient env reads, or pattern-engine code.

## Verification

Run from the repo root:

```bash
mix ci
```
