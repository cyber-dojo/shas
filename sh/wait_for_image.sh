#!/usr/bin/env bash
set -Eu

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export SH_DIR="${ROOT_DIR}/sh"

source "${SH_DIR}/lib.sh"

TAG="$(git_commit_sha | head -c7)"
MAX_ATTEMPTS=30  # every 10s for 5 minutes
ATTEMPTS=1

until docker pull cyberdojo/shas:${TAG}
do
  sleep 10
  [[ ${ATTEMPTS} -eq ${MAX_ATTEMPTS} ]] && echo "Failed!" && exit 1
  ((ATTEMPTS++))
  echo "Trying docker pull cyberdojo/shas:${TAG} again. Attempt #${ATTEMPTS}"
done
