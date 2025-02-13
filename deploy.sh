#!/bin/bash
# Copyright (C) 2016-2021 Intel Corporation
# Copyright (C) 2022 Konsulko Group
#
# SPDX-License-Identifier: GPL-2.0-only
#
# This script is meant to be consumed by travis. It's very simple but running
# a loop in travis.yml isn't a great thing.
set -e

# Allow the user to specify another command to use for building such as podman
if [ "${ENGINE_CMD}" = "" ]; then
    ENGINE_CMD="docker"
fi

# Don't deploy on pull requests because it could just be junk code that won't
# get merged
if ([ "${GITHUB_EVENT_NAME}" = "push" ] || [ "${GITHUB_EVENT_NAME}" = "workflow_dispatch" ] || [ "${GITHUB_EVENT_NAME}"  = "schedule" ])  && [ "${GITHUB_REF}" = "refs/heads/master" ]; then
    echo $DOCKER_PASSWORD | ${ENGINE_CMD} login -u $DOCKER_USERNAME --password-stdin
    ${ENGINE_CMD} push $REPO:$DISTRO_TO_BUILD-base
    ${ENGINE_CMD} push $REPO:$DISTRO_TO_BUILD-builder
fi
