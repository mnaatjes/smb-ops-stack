---
title: "Configure Production Environment for smb-ops"
tags: ["how-to", "production", "ansible", "hsl", "smb-ops"]
created_at: "2026-10-16"
---

# Configure Production Environment for smb-ops

Runbook for onboarding `smb-ops` into `homelab-ops` Ansible automation.

## 1. Register Stack in Workload Inventory

In `homelab-ops/group_vars/all/workloads/compose_stacks.yml`:

```yaml
compose_stacks:
  smb-ops:
    repo_url: "https://github.com/mnaatjes/smb-ops.git"
    version: "v1.0.0"
    target_hosts: ["prd-worker-01.lan"]
    environment_variables:
      SERVICE_HTTP_PORT: 8080
      DATA_DIR: "/opt/homelab/prod/data/smb-ops"
```

## 2. Converge Fleet Node

```bash
ansible-playbook -i inventory.ini playbooks/deploy_stack.yml -e "stack=smb-ops"
```
