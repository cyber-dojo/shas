#!/bin/bash -Eeu


# - - - - - - - - - - - - - - - - - - -
merkely_log_deployment()
{
  local -r MERKELY_OWNER=cyber-dojo
  local -r MERKELY_PIPELINE=shas
  local -r MERKELY_ENVIRONMENT="${1}"
  local -r MERKELY_HOST="${2}"
  # MERKELY_FINGERPRINT is set in sh/on_ci_publish_tagged_images.sh

	docker run \
    --env MERKELY_COMMAND=log_deployment \
    --env MERKELY_OWNER=${MERKELY_OWNER} \
    --env MERKELY_PIPELINE=${MERKELY_PIPELINE} \
    --env MERKELY_FINGERPRINT=${MERKELY_FINGERPRINT} \
    --env MERKELY_DESCRIPTION="Deployed to ${environment} in circleci pipeline" \
    --env MERKELY_ENVIRONMENT="${MERKELY_ENVIRONMENT}" \
    --env MERKELY_CI_BUILD_URL=${CIRCLE_BUILD_URL} \
    --env MERKELY_HOST="${MERKELY_HOST}" \
    --env MERKELY_API_TOKEN=${MERKELY_API_TOKEN} \
    --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
      merkely/change:latest
}

