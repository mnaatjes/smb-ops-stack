---
title: "Architecture Overview for smb-ops"
tags: ["explanation", "architecture", "hsl", "smb-ops"]
created_at: "2026-10-16"
---

# Architecture Overview for smb-ops

This document explains the runtime container topology, volume persistence model, and network boundaries governing `smb-ops`.

## 1. Homelab Systems Lifecycle (HSL) Boundary

`smb-ops` operates under strict HSL separation:
* **Declarative Configuration:** Maintained in Git and synchronized to `/opt/homelab/prod/compose/smb-ops/`.
* **State Persistence:** Preserved under `/opt/homelab/prod/data/smb-ops/` with host-managed permissions.
* **Pre-Built OCI Images:** Worker nodes pull pre-compiled container packages from registries without local compilers.

## 2. Ingress & Reverse Proxying

Client traffic enters via the host network on `${SERVICE_HTTP_PORT:-8080}`. All internal container communication is strictly encapsulated within the Docker bridge network.
