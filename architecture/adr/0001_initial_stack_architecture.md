---
status: "accepted"
date: "2026-10-16"
deciders: ["@mnaatjes"]
tags: ["docker", "compose", "architecture", "adr"]
---

# 0001: Adopt Containerized Deployment Architecture for smb-ops

## Context and Problem Statement

The platform requires a reliable containerized workload specification for `smb-ops` complying with the Homelab Systems Lifecycle (HSL).

## Decision Outcome

Chosen option: Deploy `smb-ops` via Docker Compose governed by Ansible orchestrator, isolating persistent state to `${DATA_DIR}` and pulling pre-compiled images from registry.
