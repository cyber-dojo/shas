#!/usr/bin/env bash
set -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
echo_versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  #
  echo CYBER_DOJO_SHAS_SHA="$(git_commit_sha)"
  echo CYBER_DOJO_SHAS_TAG="$(git_commit_tag)"
  #
  echo CYBER_DOJO_SHAS_CLIENT_IMAGE=cyberdojo/shas-client
  echo CYBER_DOJO_SHAS_CLIENT_PORT=9999
  #
  echo CYBER_DOJO_SHAS_CLIENT_USER=nobody
  echo CYBER_DOJO_SHAS_SERVER_USER=nobody
  #
  echo CYBER_DOJO_SHAS_CLIENT_CONTAINER_NAME=test_shas_client
  echo CYBER_DOJO_SHAS_SERVER_CONTAINER_NAME=test_shas_server
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo "$(cd "$(repo_root)" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
git_commit_tag()
{
  local -r sha="$(git_commit_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_SHAS_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  docker run --rm $(image_name) sh -c 'echo ${SHA}'
}
