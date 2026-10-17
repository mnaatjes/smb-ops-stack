# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- **Docker Compose Stack Orchestration:**
  - Configured multi-container orchestration with `frontend` (Vue 3 Nginx SPA) and `backend` (FastAPI).
  - Healthcheck coordination ensuring frontend routes only after backend reports healthy.
  - Persistent SQLite data directory volume mount mirrored under `./data`.
- **Architecture Documentation:**
  - `architecture/adr/0001_initial_stack_architecture.md`.

### Fixed
- **API Proxy Routing:** Updated `config/nginx.conf` with `rewrite ^/api/(.*)$ /$1 break;` before proxying to `http://backend:8000` to preserve endpoint path semantics and prevent trailing slash truncation.
- **CI & Formatting Compliance:**
  - Removed trailing blank lines in `compose.yml` for `yamllint` compliance.
  - Set `fetch-depth: 0` on `actions/checkout@v4` in GitHub Actions workflow to support Gitleaks history scanning.
  - Quoted workflow `on` trigger keys.

---

## [0.1.0] - 2026-10-16

### Added
- Initial stack scaffolding from `template-docker-stack`.
- Docker compose specification and Nginx reverse proxy routing.
