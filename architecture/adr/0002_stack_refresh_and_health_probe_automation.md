---
title: "ADR-0002: Stack Refresh, Dangling Image Pruning, and Health Probe Automation"
tags: ["docker", "compose", "automation", "healthcheck", "devops"]
created_at: "2026-10-20"
last_updated_at: "2026-10-20"
---

# ADR-0002: Stack Refresh, Dangling Image Pruning, and Health Probe Automation

## Context
During iterative development across the polyrepo suite (`smb-ops-backend`, `smb-ops-frontend`, `smb-ops-stack`), merged feature PRs require recreating the local development containers (`smb-ops-ui:test` and `smb-ops-api:test`). Performing this sequence manually involves multiple error-prone terminal invocations:
1. Navigating to sibling repositories and executing Docker builds.
2. Accumulation of dangling intermediate build layers on the VM host.
3. Manually invoking `docker compose up -d --force-recreate`.
4. Inspecting container health via manual `curl` polling.

## Decision
1. **Automation Script (`scripts/refresh_stack.sh`):**
   - Author a centralized shell utility inside `smb-ops-stack/scripts/` that resolves sibling repositories (`../smb-ops-frontend` and `../smb-ops-backend`).
   - Support selective flags (`--frontend-only`, `--backend-only`) or full-stack rebuild by default.
   - Execute builds using `--quiet` to prevent TUI/CLI terminal buffer flooding and crashes.
   - Automatically execute `docker image prune -f --filter "dangling=true"` after successful image compilation to preserve disk space on provisioned hosts.
   - Force-recreate compose services and poll `/health` endpoints for both backend (port 8000) and frontend reverse proxy (port 8090) with an automated timeout (30 seconds).
2. **Exclusions (`.dockerignore`):**
   - Explicitly add `scripts/` to `.dockerignore` to ensure maintenance tooling is excluded from container build contexts.
   - Note: `scripts/refresh_stack.sh` is deliberately tracked in Git (not ignored in `.gitignore`) so all maintainers and CI environments share the exact same refresh procedure.

## Consequences
- **Positive:** Single deterministic command to rebuild, prune cache, deploy, and verify the full stack; completely eliminates terminal crash vectors from verbose Docker build output; guarantees immediate verification of container readiness.
- **Negative:** Requires sibling repositories to be present at expected relative workspace paths in local development environments.
