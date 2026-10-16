---
title: "Integrate Polyrepo Frontend SPA Container Image"
tags: ["how-to", "polyrepo", "frontend", "docker", "smb-ops"]
created_at: "2026-10-16"
---

# Integrate Polyrepo Frontend SPA Container Image

This runbook documents how to connect an independently developed frontend repository (e.g. Vue 3 / Vite SPA) into `smb-ops`.

## 1. Upstream Frontend Release Contract

The upstream frontend repository must:
1. Compile and publish an OCI container image running an embedded Nginx webserver:
   `ghcr.io/mnaatjes/smb-ops-ui:vX.Y.Z`
2. Serve static single-page application assets at `/usr/share/nginx/html`.
3. Read reverse-proxy configuration from mounted `/etc/nginx/conf.d/default.conf`.

## 2. Compose Wiring in smb-ops

In `compose.yml`:
```yaml
services:
  frontend:
    image: ${FRONTEND_IMAGE:-ghcr.io/mnaatjes/smb-ops-ui:latest}
    restart: unless-stopped
    ports:
      - "${SERVICE_HTTP_PORT:-8080}}:80"
    volumes:
      - ./config/nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      backend:
        condition: service_healthy
    networks:
      - smb_ops_net
```

## 3. Alternative Edge CDN Routing

Because the frontend is decoupled into its own repository, operators may optionally deploy the SPA directly to Cloudflare Pages or Netlify instead of hosting the container locally on the homelab fleet.
