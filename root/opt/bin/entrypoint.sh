#!/usr/bin/env bash

# split off the first argument as the generator name
GENERATOR_NAME="$1"
shift

# pass the remaining arguments as options
yo "${GENERATOR_NAME}" --no-insight --skip-install "$@"
# The --no-insight flag is recommended to avoid prompts for usage collection.
# @see https://github.com/yeoman/yo/issues/20
