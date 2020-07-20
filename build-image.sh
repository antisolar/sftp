#!/bin/bash

image_name="$1"
image_version="$2"
distro_name="$3"
distro_version="$4"
latest="$5"
pull="${6:-true}"

dockerfile="Dockerfile-$distro_name"
tags=(
    "$image_version-$distro_name-$distro_version"
    "$image_version-$distro_name"
    "$distro_name"
)

if [ "$distro_name" == "debian" ]; then
    dockerfile="Dockerfile"
    tags+=("$image_version")
    if [ "$latest" == "latest" ]; then
        tags+=("latest")
    fi
fi

tag_commands=()
for tag in "${tags[@]}"; do
    tag_commands+=("--tag=$image_name:$tag")
done

docker build . \
    --build-arg "distro_version=$distro_version" \
    --pull="$pull" \
    --file="$dockerfile" \
    "${tag_commands[@]}" \
    --label="org.opencontainers.image.source=$(git remote get-url origin)" \
    --label="org.opencontainers.image.revision=$(git rev-parse HEAD)" \
    --label="org.opencontainers.image.created=$(date --rfc-3339=seconds)"
