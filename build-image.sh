#!/bin/bash

dockerfile="$1"
tags=("${@:2}")

tag_commands=()
for tag in "${tags[@]}"; do
    tag_commands+=("--tag=$tag")
done

docker build . \
    --pull="true" \
    --file="$dockerfile" \
    "${tag_commands[@]}" \
    --label="org.opencontainers.image.source=$(git remote get-url origin)" \
    --label="org.opencontainers.image.revision=$(git rev-parse HEAD)" \
    --label="org.opencontainers.image.created=$(date --rfc-3339=seconds)"
