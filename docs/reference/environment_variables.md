---
title: "Environment Variables Reference for smb-ops"
tags: ["reference", "environment", "configuration", "smb-ops"]
created_at: "2026-10-16"
---

# Environment Variables Reference for smb-ops

Authoritative specification of configuration options for `smb-ops`.

| Variable | Default | Description | Environment |
| :--- | :--- | :--- | :--- |
| `APP_ENV` | `dev` | Application lifecycle mode (`dev`, `stage`, `prod`). | All |
| `SERVICE_HTTP_PORT` | `8080` | Ingress port exposed on the host. | All |
| `DATA_DIR` | `./data` | Persistent host bind path (overridden by Ansible in prod). | All |
| `LOG_LEVEL` | `info` | Operational logging verbosity (`debug`, `info`, `warn`, `error`). | All |
