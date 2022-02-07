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

if [ "$#" -lt 2 ]; then
  echo "Must pass at least one arg, the image to push"
  exit 1
fi

if [[ -x "cosign" ]]; then
  echo "Must install cosign, refer to installation page https://docs.sigstore.dev/cosign/installation/"
  exit 1
fi

docker push $2

cosign sign "${@:2}"
