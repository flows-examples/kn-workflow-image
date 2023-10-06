#!/bin/sh
set -e

get_os() 
{
    echo $(uname | awk '{print tolower($0)}')
}

get_arch()
{
    arch=$(uname -m)
    case $(uname -m) in
    "x86_64") arch="amd64" ;;
    "aarch64") arch="arm64" ;;
    esac
    echo ${arch}
}

# Download and install the given tool
download_and_install()
{
  TOOL=$1
  FILE_NAME=$2
  URL=$3

  if [ -e "${download_path}/${FILE_NAME}" ]; then
    echo "---> ${TOOL} ${FILE_NAME} already exists in '${download_path}', skipping downloading"
  else
    mkdir -p "${download_path}"
    cd "${download_path}"
    echo "---> Downloading ${TOOL} ${FILE_NAME} to ${download_path}"
    curl -LO "${URL}"
    cd -
  fi

  echo "---> Ensuring ${TOOL} installation at ${install_path}"
  
  # We don't have 'file' in ubi8, so we use this arcaic check
  if [ "${FILE_NAME: -7}" == ".tar.gz" ]; then  
    tar -xf "${download_path}/${FILE_NAME}" -C "${download_path}"
  else
    cp "${download_path}/${FILE_NAME}" "${install_path}/${TOOL}"
    chmod +x "${install_path}/${TOOL}"
  fi
}
