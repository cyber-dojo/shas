#!/usr/bin/env bash
set -Eeu

#- - - - - - - - - - - - - - - - - - - - - - - -
build_tagged_images()
{
  build_images
  tag_images_to_latest
  check_embedded_env_var
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_images()
{
   docker-compose build --build-arg COMMIT_SHA=$(git_commit_sha)
}

#- - - - - - - - - - - - - - - - - - - - - - - -
tag_images_to_latest()
{
  docker tag ${CYBER_DOJO_SHAS_IMAGE}:$(git_commit_tag)        ${CYBER_DOJO_SHAS_IMAGE}:latest
  docker tag ${CYBER_DOJO_SHAS_CLIENT_IMAGE}:$(git_commit_tag) ${CYBER_DOJO_SHAS_CLIENT_IMAGE}:latest
  echo
  echo "echo CYBER_DOJO_SHAS_SHA=$(git_commit_sha)"
  echo "echo CYBER_DOJO_SHAS_TAG=$(git_commit_tag)"
  echo
}

# - - - - - - - - - - - - - - - - - - - - - -
check_embedded_env_var()
{
  if [ "$(git_commit_sha)" != "$(image_sha)" ]; then
    echo "ERROR: unexpected env-var inside image $(image_name):$(git_commit_tag)"
    echo "expected: 'SHA=$(git_commit_sha)'"
    echo "  actual: 'SHA=$(image_sha)'"
    exit 42
  fi
}
