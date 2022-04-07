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
  echo "Must pass at least one arg, the image to sign"
  exit 1
fi

if ! command -v cosign &> /dev/null; then
  echo "Must install cosign, please refer to installation page: https://docs.sigstore.dev/cosign/installation/"
  exit 1
fi

if ! command -v crane &> /dev/null; then
  echo "Must install crane, please refer to installation page: https://github.com/google/go-containerregistry/tree/main/cmd/crane#installation"
  exit 1
fi

crane digest $2 || $(echo "Pushing image..." && docker push $2)

cosign sign "${@:2}"
