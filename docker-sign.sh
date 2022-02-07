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
  echo "Must pass at least one arg, the image to sign"
  exit 1
fi

if [[ -x "cosign" ]]; then
  echo "Must install cosign"
  exit 1
fi

if [[ -x "crane" ]]; then
  echo "Must install crane"
  exit 1
fi

crane digest $1 || $( echo "Pushing image..." && docker push $1)

cosign sign $@