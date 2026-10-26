#! /usr/bin/env bash
set -euo pipefail

name="$1"

if [ -z "${name}" ]; then
    echo "missing name argument"
    exit 1
fi

version_file="$(<"apps/${name}/VERSION")"

# Base for the unstable version.
# - Plain X.Y.Z:         bump the patch (1.13.0 -> 1.13.1)
# - Prerelease/backport: keep the version verbatim (1.11.3-backport.3)
if [[ "${version_file}" == *-* ]]; then
    unstable_base="${version_file}"
else
    unstable_base="$(awk -F. '{print $1"."$2"."($3+1)}' "apps/${name}/VERSION")"
fi

# Get the commit date
commit_date="$(git log -n1 --format=%cd --date=format:%Y%m%d)"

printf -v unstable '%s-snapshot.%s.%s.0.v%s' "${unstable_base}" "${commit_date}" "${GITHUB_RUN_NUMBER}" "${GITHUB_SHA:0:8}"

# Export outputs
cat <<EOF | tee -a "${GITHUB_OUTPUT}"
unstable=${unstable}
stable=${version_file}
EOF
