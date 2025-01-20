#!/usr/bin/env bash

# Disable undeclared variable linting.
# shellcheck disable=SC2154

# We want globbing with `$files`.
# shellcheck disable=SC2086

gh release create "${tag}" \
  --title "${title}" \
  --notes "${body}" \
  --repo "${repo_owner}/${repo_name}" \
  ${files}
