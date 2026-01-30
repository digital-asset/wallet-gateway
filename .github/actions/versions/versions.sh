#! /usr/bin/env bash
set -euo pipefail

version_file="$(<VERSION)"

# Bump the patch version
minor_bump="$(awk -F. '{s=$3; sub(/^[0-9]+/, "", s); print $1"."$2"."($3+1)s}' VERSION)"

# Get the commit date
commit_date="$(git log -n1 --format=%cd --date=format:%Y%m%d)"

printf -v unstable '%s-snapshot.%s.%s.0.v%s' "${minor_bump}" "${commit_date}" "${GITHUB_RUN_NUMBER}" "${GITHUB_SHA:0:8}"

# Export outputs
cat <<EOF | tee -a "${GITHUB_OUTPUT}"
unstable=${unstable}
stable=${version_file}
EOF
