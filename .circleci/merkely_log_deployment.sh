#!/bin/bash -Eeu

readonly MERKELY_CHANGE=merkely/change:latest
readonly MERKELY_OWNER=cyber-dojo
readonly MERKELY_PIPELINE=shas

# - - - - - - - - - - - - - - - - - - -
merkely_fingerprint()
{
  echo "docker://${CYBER_DOJO_SHAS_IMAGE}:${CYBER_DOJO_SHAS_TAG}"
}

# - - - - - - - - - - - - - - - - - - -
kosli_log_deployment()
{
  local -r MERKELY_ENVIRONMENT="${1}"
  local -r MERKELY_HOST="${2}"

	docker run \
    --env MERKELY_COMMAND=log_deployment \
    --env MERKELY_OWNER=${MERKELY_OWNER} \
    --env MERKELY_PIPELINE=${MERKELY_PIPELINE} \
    --env MERKELY_FINGERPRINT=$(kosli_fingerprint) \
    --env MERKELY_DESCRIPTION="Deployed to ${MERKELY_ENVIRONMENT} in Github Actions pipeline" \
    --env MERKELY_ENVIRONMENT="${MERKELY_ENVIRONMENT}" \
    --env MERKELY_CI_BUILD_URL=${CIRCLE_BUILD_URL} \
    --env MERKELY_HOST="${MERKELY_HOST}" \
    --env MERKELY_API_TOKEN=${MERKELY_API_TOKEN} \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
      merkely/change:latest
}

# - - - - - - - - - - - - - - - - - - -
VERSIONER_URL=https://raw.githubusercontent.com/cyber-dojo/versioner/master
export $(curl "${VERSIONER_URL}/app/.env")
export CYBER_DOJO_SHAS_TAG="${CIRCLE_SHA1:0:7}"
docker pull ${CYBER_DOJO_SHAS_IMAGE}:${CYBER_DOJO_SHAS_TAG}

readonly ENVIRONMENT="${1}"
readonly HOSTNAME="${2}"
kosli_log_deployment "${ENVIRONMENT}" "${HOSTNAME}"
