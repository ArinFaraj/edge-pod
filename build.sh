#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/edge_pod_server"

rm -rf build/linux_arm64
dart build cli --target bin/main.dart --target-os=linux --target-arch=arm64 -o build/linux_arm64

cp -R config build/linux_arm64/bundle/config
cp -R migrations build/linux_arm64/bundle/migrations

tar -czf ../dist.tgz -C build/linux_arm64/bundle .
sha256sum ../dist.tgz > ../dist.tgz.sha256

echo "Linux ARM64 bundle built successfully at dist.tgz"
