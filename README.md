# Docker CLI plugins for [`cosign`](https://github.com/sigstore/cosign)

These plugins make it slightly easier to use `cosign` using `docker` CLI commands.

They require that you have [`cosign`](https://docs.sigstore.dev/cosign/installation/) and [`crane`](https://github.com/google/go-containerregistry/tree/main/cmd/crane#installation) installed.

## Install

Docker CLI plugins are found in `~/.docker/cli-plugins`, with names like `docker-<command>`.

You can fetch and install these like so:

```
for cmd in \
  docker-pullx \
  docker-pushx \
  docker-sign \
  docker-verify; do
    curl -o ~/.docker/cli-plugins/${cmd} \
        https://raw.githubusercontent.com/imjasonh/cosign-docker-cli-plugins/${cmd}.sh && \
        chmod ~/.docker/cli-plugins/${cmd}
done
```

## Commands

### `docker pushx <img>`

This runs `docker push <img>` then `cosign sign <img>`, passing any remaining args to `cosign push`.

### `docker pullx <img>`

This runs `cosign verify <img>` then `docker pull <img>`, passing any remaining args to `cosign verify`.

### `docker sign <img>`

This ensures the image exists in the registry, and if not, pushes it using `docker push <img>`.
Then, it runs `cosign sign <img>`, passing any remaining args to `cosign sign`.

### `docker verify <img>`

This is simply a wrapper for `cosign verify`, passing all args to `cosign verify`.

### `COSIGN_EXPERIMENTAL`

All of these plugins support the `COSIGN_EXPERIMENTAL` environment variable, which enables keyless signing and verification.

For example:

```
COSIGN_EXPERIMENTAL=1 docker pullx ghcr.io/shipwright-io/build/shipwright-build-controller
```
