#! /usr/bin/env bash
set -euo pipefail

# Clear the summary and outputs if there is an error
trap 'rm -vf ${GITHUB_STEP_SUMMARY} ${GITHUB_OUTPUT}' ERR

# Checks if a var is empty
function required() {
  if [ -z "${!1}" ]; then
    echo "'$1' is a required input"
    return 1
  fi
}

function build-push() {
  local title output version registry
  case "$1" in
  UNSTABLE)
    title='Unstable'
    output='unstable-package'
    version="${VERSIONS_UNSTABLE}"
    registry="${REGISTRY_UNSTABLE}"
    ;;
  STABLE)
    title='Stable'
    output='stable-package'
    version="${VERSIONS_STABLE}"
    registry="${REGISTRY_STABLE}"
    ;;
  *)
    echo "Unknown package type: $1"
    exit 1
    ;;
  esac

  local package="${temp}/${name}-${version}.tgz"

  # Start the package summary block
  {
    echo "### ${title} Package"
    echo '```yaml'
  } >>"${GITHUB_STEP_SUMMARY}"

  # Build and push the chart while
  helm package "${CHART}" --version "${version}" --destination "${temp}"

  # Tee the push output to the summary
  helm push --username "${USERNAME}" --password "${PASSWORD}" "${package}" "oci://${registry}" 2>&1 | tee -a "${GITHUB_STEP_SUMMARY}"

  # Close the block
  echo '```' >>"${GITHUB_STEP_SUMMARY}"

  # Write the output variable
  echo "${output}=${package}" | tee -a "${GITHUB_OUTPUT}"
}

# Inputs
inputs=(
  CHART
  REGISTRY_STABLE
  REGISTRY_UNSTABLE
  RELEASE_BRANCHES
  VERSIONS_STABLE
  VERSIONS_UNSTABLE
  USERNAME
  PASSWORD
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

# Make a temp directory for building
temp="$(mktemp -d)"

# The chart name as it appears in the Chart.yaml file
name="$(yq .name "${CHART}/Chart.yaml")"

# Start the summary block
{
  echo '## Helm Build summary'
  echo "_For ${CHART}_"
  echo '### Chart.yaml'
  echo '```yaml'
  cat "${CHART}/Chart.yaml"
  echo '```'
} >>"${GITHUB_STEP_SUMMARY}"

# Unstable package

# Every commit builds and pushes the unstable version of the chart
build-push UNSTABLE

# Stable package

# Only ever build a stable package if we are on a release branch AND the release
# package doesn't already exist

# Check if we are on a release branch
for branch in ${RELEASE_BRANCHES}; do
  if [[ "${GITHUB_REF_NAME}" == ${branch} ]]; then
    echo "Release branch detected: ${GITHUB_REF_NAME}"

    # Check that the release doesn't already exist
    if helm show chart --username "${USERNAME}" --password "${PASSWORD}" "oci://${REGISTRY_STABLE}/${name}:${VERSIONS_STABLE}" >/dev/null; then
      echo "Stable package release already exists"
    else
      build-push STABLE
    fi
    break
  fi
done
