#!/usr/bin/env bash
# file: docker-prune-cache.sh
# author: Michael Moscovitch
#
# Copyright (c) 2026 Pathway Communications
#
# Licensed under the MIT License. See LICENSE file for details.

set -euo pipefail

# Prune options: keep only cache used in the last 48h.
# Prefer arrays to avoid word splitting/quoting issues.
PRUNE_OPTS1=(--filter until=48h --max-used-space 10GB)
PRUNE_OPTS2=(--filter until=48h --keep-storage 10GB)

echo "==> Docker disk usage BEFORE:"
docker system df || true

if docker buildx version >/dev/null 2>&1; then
  echo "==> Buildx detected"

  # Optional: ensure we're pruning the intended builder
  # Uncomment and set if you use a named builder:
  # docker buildx use my-builder

  echo "==> Buildx disk usage:"
  docker buildx du || true

  echo "==> Pruning Buildx cache (unused records older than 24h)"
  # -a includes internal/frontend helper images; remove if you want to be less aggressive.
  docker buildx prune -f "${PRUNE_OPTS1[@]}"

  echo "==> Buildx disk usage AFTER:"
  docker buildx du || true

else
  echo "==> Buildx not installed; using classic builder prune"
  # Remove unused BuildKit cache with the classic command
  docker builder prune -f "${PRUNE_OPTS2[@]}"
fi

echo "==> Docker disk usage AFTER:"
docker system df || true
