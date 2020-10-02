#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/sh/augmented_docker_compose.sh"

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  local -r dil=$(docker image ls --format "{{.Repository}}:{{.Tag}}")
  remove_all_but_latest "${dil}" "${CYBER_DOJO_SHAS_CLIENT_IMAGE}"
  remove_all_but_latest "${dil}" "${CYBER_DOJO_SHAS_IMAGE}"
  build_images
  tag_images_to_latest
  check_embedded_env_var
}

# - - - - - - - - - - - - - - - - - - - - - -
remove_all_but_latest()
{
  local -r docker_image_ls="${1}"
  local -r name="${2}"
  for image_name in `echo "${docker_image_ls}" | grep "${name}:"`
  do
    if [ "${image_name}" != "${name}:latest" ]; then
      if [ "${image_name}" != "${name}:<none>" ]; then
        docker image rm "${image_name}"
      fi
    fi
  done
  docker system prune --force
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
  augmented_docker_compose \
    build \
    --build-arg COMMIT_SHA=$(git_commit_sha)
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag ${CYBER_DOJO_SHAS_IMAGE}:$(image_tag)        ${CYBER_DOJO_SHAS_IMAGE}:latest
  docker tag ${CYBER_DOJO_SHAS_CLIENT_IMAGE}:$(image_tag) ${CYBER_DOJO_SHAS_CLIENT_IMAGE}:latest
  echo
  echo "CYBER_DOJO_SHAS_SHA=$(git_commit_sha)"
  echo "CYBER_DOJO_SHAS_TAG=$(image_tag)"
  echo
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(sha_in_image)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(image_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(sha_in_image)'"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - - - - -
git_commit_sha()
{
  echo $(cd "${SH_DIR}" && git rev-parse HEAD)
}

# - - - - - - - - - - - - - - - - - - - - - -
image_name()
{
  echo "${CYBER_DOJO_SHAS_IMAGE}"
}

# - - - - - - - - - - - - - - - - - - - - - -
image_sha()
{
  echo "${CYBER_DOJO_SHAS_SHA}"
}

# - - - - - - - - - - - - - - - - - - - - - -
image_tag()
{
  echo "${CYBER_DOJO_SHAS_TAG}"
}

# - - - - - - - - - - - - - - - - - - - - - -
sha_in_image()
{
  docker run --rm $(image_name):$(image_tag) sh -c 'echo -n ${SHA}'
}
