#!/usr/bin/env bash
set -euo pipefail

# Build the Hugo demo below /hugo/.
hugo --minify --cleanDestinationDir "$@"

# Keep the existing static site at the domain root during the migration.
mkdir -p public
cp index.html styles.css favicon.svg robots.txt sitemap.xml CNAME public/
cp -R blogi cv public/
