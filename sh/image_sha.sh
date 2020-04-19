#!/bin/bash -Eeu

image_sha()
{
  docker run --rm ${CYBER_DOJO_SHAS_IMAGE}:latest sh -c 'echo ${SHA}'
}
