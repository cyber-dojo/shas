#!/usr/bin/env bash
set -Eeu

#- - - - - - - - - - - - - - - - - - - - - - - -
remove_old_images()
{
  local -r dil=$(docker image ls --format "{{.Repository}}:{{.Tag}}")
  remove_all_but_latest "${dil}" "${CYBER_DOJO_SHAS_CLIENT_IMAGE}"
  remove_all_but_latest "${dil}" "${CYBER_DOJO_SHAS_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_all_but_latest()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  for image in `echo "${docker_image_ls}" | grep "${name}:"`
  do
    if [ "${image}" != "${name}:latest" ]; then
      if [ "${image}" != "${name}:<none>" ]; then
        docker image rm "${image}"
      fi
    fi
  done
  docker system prune --force
}
