#!/bin/sh

# Install kn (https://knative.dev/docs/client/install-kn/#install-the-knative-cli) and kn workflow

set -e

source utils.sh

# Vars
install_path=$1
default_kn_version=v1.11.0
default_kn_workflow_version=0.31.0
download_path="/tmp/download/"

# Defaults
if [[ -z ${KN_VERSION} ]]; then
  KN_VERSION=$default_kn_version
fi
if [[ -z ${KN_WORKFLOW_VERSION} ]]; then
  KN_WORKFLOW_VERSION=$default_kn_workflow_version
fi

if [ -z "${install_path}" ]; then
  install_path="/usr/local/bin"
fi
mkdir -p ${install_path}

echo "---> kn version to install is ${KN_VERSION} and workflow plugin is ${KN_WORKFLOW_VERSION}"

arch=$(get_arch)
os=$(get_os)

download_and_install "kn" "kn-${os}-${arch}" "https://github.com/knative/client/releases/download/knative-${KN_VERSION}/kn-${os}-${arch}"
download_and_install "kn-workflow" "kn-workflow-${os}-${arch}-${KN_WORKFLOW_VERSION}" "https://github.com/kiegroup/kie-tools/releases/download/${KN_WORKFLOW_VERSION}/kn-workflow-${os}-${arch}-${KN_WORKFLOW_VERSION}"
