#!/usr/bin/env bash
set -euo pipefail

# Build the production Hugo site at the domain root.
hugo --minify --cleanDestinationDir "$@"
