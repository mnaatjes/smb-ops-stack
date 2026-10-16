---
title: "Deploy smb-ops Locally"
tags: ["how-to", "docker", "local", "smb-ops"]
created_at: "2026-10-16"
---

# Deploy smb-ops Locally

Practical runbook for running `smb-ops` on developer workstations.

## Prerequisites

* Docker Engine 24+ & Docker Compose v2.
* Port `8080` available on host.

## Commands

```bash
cp .env.example .env
docker compose up -d
docker compose ps
```
