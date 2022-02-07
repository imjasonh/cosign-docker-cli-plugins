#! /usr/bin/env bash

set -e

if [[ "$1" == "docker-cli-plugin-metadata" ]]; then
  cat << EOF
{
  "SchemaVersion": "0.1.0",
  "Vendor": "github.com/imjasonh/cosign-docker-cli-plugins"
}
EOF
  exit
fi

if [ "$#" -lt 1 ]; then
  echo "Must pass at least one arg, the image to pull"
  exit 1
fi

if [[ -x "cosign" ]]; then
  echo "Must install cosign"
  exit 1
fi

cosign verify $@

docker pull $1
