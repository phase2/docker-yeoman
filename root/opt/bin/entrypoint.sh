#!/usr/bin/env bash
GENERATOR="$1"
shift
yo "${GENERATOR}" --no-insight --skip-install "$@"
