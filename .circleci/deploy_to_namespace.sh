#!/bin/bash -Eeu

deploy_to_namespace()
{
  local -r namespace="${1}" # beta|prod

  # Get gcloud_init(), helm_init(), helm_upgrade_probe_yes_prometheus_yes()
  local -r K8S_URL=https://raw.githubusercontent.com/cyber-dojo/k8s-install/master
  local -r VERSIONER_URL=https://raw.githubusercontent.com/cyber-dojo/versioner/master
  source <(curl "${K8S_URL}/sh/deployment_functions.sh")

  # Set CYBER_DOJO_SHAS_IMAGE, CYBER_DOJO_SHAS_PORT, CYBER_DOJO_SHAS_TAG
  export $(curl "${VERSIONER_URL}/app/.env")
  readonly CYBER_DOJO_SHAS_TAG="${CIRCLE_SHA1:0:7}"

  local -r MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local -r YAML_VALUES_FILE="${MY_DIR}/k8s-general-values.yml"

  gcloud_init
  helm_init

  helm_upgrade_probe_yes_prometheus_yes \
     "${namespace}" \
     "shas" \
     "${CYBER_DOJO_SHAS_IMAGE}" \
     "${CYBER_DOJO_SHAS_TAG}" \
     "${CYBER_DOJO_SHAS_PORT}" \
     "${YAML_VALUES_FILE}"
}
