#! /usr/bin/env bash
set -euo pipefail

# Checks if a var is empty
function required() {
  if [ -z "${!1}" ]; then
    echo "'$1' is a required input"
    return 1
  fi
}

# Outputs the full tag, registry/name:tag
function full-tag() {
  printf '%s/%s:%s' "$1" "${NAME}" "$2"
}

# Sanitizes a tag
sanitize-tag() {
  local tag="$1"

  # Replace forward slashes with hyphens
  tag="${tag//\//-}"

  # Remove any characters that are NOT alphanumeric, '.', '-', or '_'
  # Remove leading periods or dashes (tags cannot start with . or -)
  tag=$(
    sed -E \
      -e 's/[^a-zA-Z0-9_.-]//g' \
      -e 's/^[\.-]+//' \
      <<<"${tag}"
  )

  # Truncate to 128 characters (tag limit)
  tag="${tag:0:128}"

  # Output
  echo "${tag}"
}

# Inputs
inputs=(
  NAME
  REGISTRY_STABLE
  REGISTRY_UNSTABLE
  RELEASE_BRANCHES
  VERSIONS_STABLE
  VERSIONS_UNSTABLE
)

failed=false
for input in "${inputs[@]}"; do
  if ! required "${input}"; then
    failed=true
  fi
done

if [ "${failed}" == 'true' ]; then
  exit 1
fi

# Outputs
tags_unstable=()
tags_stable=()
tags=()

# Unstable tags

# All unstable images get two tags:
# 1. The unstable version
# 2. The sanitized branch name (floaty)

tags_unstable+=("$(full-tag "${REGISTRY_UNSTABLE}" "${VERSIONS_UNSTABLE}")")

sanitize_branch_name="$(sanitize-tag "${GITHUB_REF_NAME}")"
tags_unstable+=("$(full-tag "${REGISTRY_UNSTABLE}" "${sanitize_branch_name}")")

# Stable tags

# Only ever provide stable tags if we are on a release branch AND the release
# image doesn't already exist

# Check if we are on a release branch
is_release_branch=false
for branch in ${RELEASE_BRANCHES}; do
  if [ "${GITHUB_REF_NAME}" == "${branch}" ]; then
    is_release_branch=true
    echo "Release branch detected: ${GITHUB_REF_NAME}"
    break
  fi
done

# If on a release branch, check if release image already exists
if [ "${is_release_branch}" == 'true' ]; then
  check_image="$(full-tag "${REGISTRY_STABLE}" "${VERSIONS_STABLE}")"

  if docker manifest inspect "${check_image}" >/dev/null; then
    echo "${check_image} already exists"
  else
    echo "${check_image} does not exist"
    tags_stable+=("${check_image}")
  fi

fi

# All tags
tags+=("${tags_unstable[@]}")
tags+=("${tags_stable[@]}")

# Export outputs

# Tags are a ',' delimited list.
IFS=','

cat <<EOF | tee -a "${GITHUB_OUTPUT}"
tags-unstable=${tags_unstable[*]}
tags-stable=${tags_stable[*]}
tags=${tags[*]}
EOF
