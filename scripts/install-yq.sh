#!/bin/sh
set -e

source utils.sh

install_path=$1
default_yq_version='v4.35.2'
arch=$(get_arch)
os=$(get_os)

if [[ -z ${YQ_VERSION} ]]; then
  YQ_VERSION=$default_yq_version
fi

if [ -z "${install_path}" ]; then
  install_path="/usr/local/bin"
fi
mkdir -p ${install_path}

file_name=yq_${os}_${arch}.tar.gz
download_path=/tmp/downloads

download_and_install "yq" "${file_name}" "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${file_name}"

mv ${download_path}/yq_${os}_${arch} ${install_path}/yq
