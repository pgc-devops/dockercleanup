#!/usr/bin/env bash
# file: docker-prune-images.sh
# author: Michael Moscovitch
#
# Copyright (c) 2026 Pathway Communications
#
# Licensed under the MIT License. See LICENSE file for details.

set -euo pipefail

# Prune options: keep only items used in the last 48h.
# Prefer arrays to avoid word splitting/quoting issues.
PRUNE_OPTS1=(--filter until=48h)

echo "==> Before:"
df -h
docker system df || true

# run docker prune. add -a to remove all unused images not just dangling ones
echo "==> Pruning containers"
docker container prune -f

echo "==> Pruning images"
docker image prune -a -f

echo "==> Pruning volumes"
docker volume prune -f

echo "==> Pruning networks"
docker network prune -f

echo "==> Full system prune (includes networks and build cache)"
docker system prune -f ${PRUNE_OPTS1[@]}

echo "==> After:"
docker system df || true
df -h
