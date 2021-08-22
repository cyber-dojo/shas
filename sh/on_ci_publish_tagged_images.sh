#!/bin/bash -Ee

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images()
{
  echo
  if ! on_ci; then
    echo 'not on CI so not publishing tagged images'
  else
    echo 'on CI so publishing tagged images'
    docker push "$(image_name):$(git_commit_tag)"
    docker push "$(image_name):latest"
    local -r digest=$(docker inspect $(image_name):$(git_commit_tag) | jq --raw-output '.[].RepoDigests[]' | cut -d: -f2)
    # Make MERKELY_FINGERPRINT available for subsequent CI pipeline steps
    # See https://circleci.com/docs/2.0/env-vars/#using-parameters-and-bash-environment
    echo "export MERKELY_FINGERPRINT=sha256://${digest}/$(image_name):$(git_commit_tag)" >> $BASH_ENV
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLECI:-}" ]
}
