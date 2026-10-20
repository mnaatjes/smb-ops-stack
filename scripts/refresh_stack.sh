#!/usr/bin/env bash
# ==============================================================================
# Stack Refresh & Health Verification Script
# Builds sibling repositories, prunes dangling layers, recreates containers,
# and verifies healthcheck status.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="$(cd "${STACK_DIR}/.." && pwd)"

BACKEND_DIR="${WORKSPACE_ROOT}/smb-ops-backend"
FRONTEND_DIR="${WORKSPACE_ROOT}/smb-ops-frontend"

BUILD_BACKEND=true
BUILD_FRONTEND=true

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --frontend-only)
      BUILD_BACKEND=false
      BUILD_FRONTEND=true
      shift
      ;;
    --backend-only)
      BUILD_BACKEND=true
      BUILD_FRONTEND=false
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--frontend-only | --backend-only]"
      exit 0
      ;;
    *)
      echo "Unknown flag: $1"
      echo "Usage: $0 [--frontend-only | --backend-only]"
      exit 1
      ;;
  esac
done

echo "==> [1/5] Validating workspace directories..."
[[ -d "${STACK_DIR}" ]] || { echo "Error: Missing stack directory ${STACK_DIR}"; exit 1; }

# Build Backend Image
if [[ "${BUILD_BACKEND}" == true ]]; then
  echo "==> [2/5] Building backend test image (smb-ops-api:test)..."
  if [[ -d "${BACKEND_DIR}" ]]; then
    docker build --quiet -t smb-ops-api:test "${BACKEND_DIR}"
    echo "    Backend image built successfully."
  else
    echo "Warning: ${BACKEND_DIR} not found. Skipping backend build."
  fi
else
  echo "==> [2/5] Skipping backend image build (--frontend-only)."
fi

# Build Frontend Image
if [[ "${BUILD_FRONTEND}" == true ]]; then
  echo "==> [3/5] Building frontend test image (smb-ops-ui:test)..."
  if [[ -d "${FRONTEND_DIR}" ]]; then
    docker build --quiet -t smb-ops-ui:test "${FRONTEND_DIR}"
    echo "    Frontend image built successfully."
  else
    echo "Warning: ${FRONTEND_DIR} not found. Skipping frontend build."
  fi
else
  echo "==> [3/5] Skipping frontend image build (--backend-only)."
fi

# Prune Dangling Build Cache
echo "==> [4/5] Pruning dangling Docker build layers..."
docker image prune -f --filter "dangling=true" > /dev/null 2>&1 || true

# Recreate Stack Containers
echo "==> [5/5] Recreating smb-ops stack containers..."
cd "${STACK_DIR}"
docker compose up -d --force-recreate

# Automated Healthcheck Polling
echo "==> Verifying service health..."
MAX_WAIT_SECONDS=30
WAITED=0
FRONTEND_OK=false

while [[ ${WAITED} -lt ${MAX_WAIT_SECONDS} ]]; do
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8090/ || true)
  API_HEALTH_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8090/api/health || true)

  if [[ "${HTTP_CODE}" == "200" && "${API_HEALTH_CODE}" == "200" ]]; then
    FRONTEND_OK=true
    break
  fi

  sleep 2
  WAITED=$((WAITED + 2))
done

if [[ "${FRONTEND_OK}" == true ]]; then
  echo "=================================================================="
  echo " Stack refresh complete! All health probes verified in ${WAITED}s."
  echo " - Frontend SPA: http://localhost:8090/"
  echo " - Backend API:  http://localhost:8090/api/health"
  echo "=================================================================="
else
  echo "Error: Health verification timed out after ${MAX_WAIT_SECONDS}s."
  docker compose ps
  exit 1
fi
