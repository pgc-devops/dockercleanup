#!/usr/bin/env bash
# file: docker-clean-logs.sh
# author: Michael Moscovitch
#
# Copyright (c) 2026 Pathway Communications
#
# Licensed under the MIT License. See LICENSE file for details.

# run on the docker host to clean up old and large container logs
containerdir=/var/lib/docker/containers
if [ -d ${containerdir} ]; then
    echo "==> Removing old container JSON logs (safe)"
    find ${containerdir} -type f -name "*-json.log.?" -mtime +30 -delete
    echo "==> Truncating large container JSON logs (safe)"
    find ${containerdir} -type f -name "*-json.log" -size +1M -exec truncate -s 0 {} \;
fi
