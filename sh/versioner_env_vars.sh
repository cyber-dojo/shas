#!/bin/bash -Eeu

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_sha()
{
  echo "$(cd "${ROOT_DIR}" && git rev-parse HEAD)"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
get_image_tag()
{
  local -r sha="$(get_image_sha)"
  echo "${sha:0:7}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  echo CYBER_DOJO_SHAS_SHA="$(get_image_sha)"
  echo CYBER_DOJO_SHAS_TAG="$(get_image_tag)"
  echo CYBER_DOJO_CLIENT_PORT=9999
  echo CYBER_DOJO_CLIENT_USER=nobody
  echo CYBER_DOJO_SERVER_USER=nobody
  echo CYBER_DOJO_SHAS_CLIENT_IMAGE=cyberdojo/shas-client
}
