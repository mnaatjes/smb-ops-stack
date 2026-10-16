# smb-ops

SMB Operations multi-container stack

Adheres to the **Homelab Systems Lifecycle (HSL)** and **ADR 0025** container deployment standards.

---

## 1. Quick Start (Local Development)

```bash
# 1. Copy environment template
cp .env.example .env

# 2. Start container stack
docker compose up -d

# 3. View logs
docker compose logs -f
```

Stack will be available at `http://localhost:8080`.

---

## 2. Directory Structure

```text
smb-ops/
├── compose.yml              # Container orchestration specification
├── .env.example             # Environment variable contract
├── config/                  # Read-only configuration mounts

├── architecture/            # Unified Process engineering plane
│   ├── adr/                 # Architecture Decision Records
│   ├── designs/             # Software Design Documents
│   ├── use-cases/           # Use Case Specifications
│   └── risk/                # Boehm Risk Register


└── docs/                    # Diataxis operator documentation
    ├── tutorials/           # Step-by-step beginner guides
    ├── how-to/              # Problem-oriented runbooks
    ├── reference/           # Technical specifications
    └── explanation/         # High-level background discussions

```

---

## 3. Production Deployment (HSL)

This stack is deployed via `homelab-ops` Ansible automation. In production:
* Container images are pulled from registry (`ghcr.io/mnaatjes`).
* Runtime secrets and environment variables are injected into `/opt/homelab/prod/compose/smb-ops/.env` from Ansible Vault.
* Persistent state is mounted from `/opt/homelab/prod/data/smb-ops/`.
