#!/usr/bin/env bash
# file: docker-prune-images.sh
# author: Michael Moscovitch
#
# Copyright (c) 2026 Pathway Communications
#
# Licensed under the MIT License. See LICENSE file for details.

set -euo pipefail
echo "==> Before:"
df -h
docker system df || true

echo "==> Pruning containers"
docker container prune -f

echo "==> Pruning images"
docker image prune -a -f

echo "==> Pruning volumes"
docker volume prune -f

echo "==> Full system prune (includes networks)"
docker system prune -a --volumes -f

echo "==> After:"
docker system df || true
df -h
