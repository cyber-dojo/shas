#!/bin/bash -Eeu

export ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SH_DIR="${ROOT_DIR}/sh"
source "${SH_DIR}/build_tagged_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up.sh"
source "${SH_DIR}/ip_address.sh"
source "${SH_DIR}/echo_versioner_env_vars.sh"
export $(echo_versioner_env_vars)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  build_tagged_images
  containers_up api-demo
  echo
  demo
  echo
  if [ "${1:-}" == '--no-browser' ]; then
    containers_down
  else
    open "http://${IP_ADDRESS}:80/shas/index"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  echo API
  curl_json_body_200 alive
  curl_json_body_200 ready
  curl_json_body_200 sha
  echo
  curl_200  assets/app.css 'Content-Type: text/css'
  echo
  curl_200  index saver
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r route="${1}" # eg alive
  curl  \
    --data "" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r route="${1}"   # eg group_choose
  local -r pattern="${2}" # eg exercise
  curl  \
    --fail \
    --request GET \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(log_filename)" | head -n 1)
  echo "$(tab)GET ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_SHAS_PORT}"; }
tab() { printf '\t'; }
log_filename() { echo -n /tmp/shas.log ; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo "$@"
