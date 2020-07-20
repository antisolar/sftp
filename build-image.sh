#!/bin/bash

image_name="$1"
image_version="$2"
distro_name="$3"
distro_version="$4"
tags=("${@:5}")

if [ "$distro_name" == "debian" ]; then
    dockerfile="Dockerfile"
else
    dockerfile="Dockerfile-$distro_name"
fi

tag_commands=()
for tag in "${tags[@]}"; do
    tag_commands+=("--tag=$image_name:$tag")
done

docker build . \
    --build-arg "distro_version=$distro_version" \
    --pull="true" \
    --file="$dockerfile" \
    "${tag_commands[@]}" \
    --label="org.opencontainers.image.source=$(git remote get-url origin)" \
    --label="org.opencontainers.image.revision=$(git rev-parse HEAD)" \
    --label="org.opencontainers.image.created=$(date --rfc-3339=seconds)"
