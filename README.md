# Docker CLI plugins for [`cosign`](https://github.com/sigstore/cosign)

These plugins aim to make it slightly easier to use `cosign` using `docker` CLI commands.

They require that you have [`cosign`](https://docs.sigstore.dev/cosign/installation/) and [`crane`](https://github.com/google/go-containerregistry/tree/main/cmd/crane#installation) installed.

⚠️ **These plugins are unofficial, unsupported, experimental, and likely to change.** ⚠️

Ideally, this functionality would be built into the `docker` CLI directly (see https://github.com/docker/cli/issues/3283).
Until then, CLI plugins are simply a temporary solution.

## Install

Docker CLI plugins are found in `~/.docker/cli-plugins`, with names like `docker-<command>`.

You can fetch and install these from this repo like so:

```
mkdir -p ~/.docker/cli-plugins
for cmd in docker-pullx docker-pushx docker-sign docker-verify; do
    curl https://raw.githubusercontent.com/imjasonh/cosign-docker-cli-plugins/main/${cmd}.sh \
        -o ~/.docker/cli-plugins/${cmd} && \
        chmod +x ~/.docker/cli-plugins/${cmd}
done
```

_Please inspect the source of these plugins before using them; you are implicitly trusting them to make security decisions for you._

## Commands

### `docker pushx [image]`

This runs `docker push [image]` then `cosign sign [image]`, passing any remaining args to `cosign sign`.

- _Note:_ This will not affect images pushed during `docker buildx --push`.
- _Note:_ It's strongly recommended that you sign images by digest, to avoid race conditions.
  This command does not currently do this.
  For this reason, you should prefer to `docker push` the image separately, then `cosign sign` the pushed image by digest.

### `docker pullx [image]`

This runs `cosign verify [image]` then `docker pull [image]`, passing any remaining args to `cosign verify`.

- _Note:_ This will not affect images pulled during builds, for example in `FROM [image]` statements.
- _Note:_ It's strongly recommended that you verify images by digest, to avoid race conditions.

### `docker sign [image]`

This ensures the image exists in the registry, and if not, pushes it using `docker push [image]`.
Then, it runs `cosign sign [image]`, passing any remaining args to `cosign sign`.

- _Note:_ It's strongly recommended that you sign images by digest, to avoid race conditions.
  For this reason, you should prefer to `docker push` the image separately, then `cosign sign` the pushed image by digest.

### `docker verify [image]`

This is simply a wrapper for `cosign verify`, passing all args to `cosign verify`.

- _Note:_ It's strongly recommended that you verify images by digest, to avoid race conditions.

### `COSIGN_EXPERIMENTAL`

All of these plugins support the `COSIGN_EXPERIMENTAL` environment variable, which enables keyless signing and verification.

For example:

```
COSIGN_EXPERIMENTAL=1 docker pullx ghcr.io/shipwright-io/build/shipwright-build-controller
```
