#!/bin/sh
# Layered PanVK selector: prefer kisak (Ubuntu multiarch) Mesa PanVK when present,
# otherwise fall back to the Yocto /usr/lib PanVK. Keeps the Mali from being
# enumerated twice by disabling the distro-shipped panfrost ICD manifests.
set -eu

KISAK_LIB=/usr/lib/aarch64-linux-gnu/libvulkan_panfrost.so
YOCTO_LIB=/usr/lib/libvulkan_panfrost.so
ACTIVE_LINK=/etc/vulkan/panvk-active.so
ICD_OUT=/etc/vulkan/icd.d/00-panvk-layer.json
DISTRO_ICD_DIR=/usr/share/vulkan/icd.d
TAG=.disabled-by-panvk-layer

mkdir -p /etc/vulkan/icd.d

# 1. choose driver: kisak if installed, else yocto
if [ -f "$KISAK_LIB" ]; then
    TARGET="$KISAK_LIB"
else
    TARGET="$YOCTO_LIB"
fi
ln -sfn "$TARGET" "$ACTIVE_LINK"

# 2. write our single canonical panfrost ICD manifest
cat > "$ICD_OUT" <<JSON
{
    "ICD": {
        "api_version": "1.4.348",
        "library_path": "$ACTIVE_LINK"
    },
    "file_format_version": "1.0.1"
}
JSON

# 3. neutralise distro panfrost manifests so the Mali is listed only once
for f in "$DISTRO_ICD_DIR"/*panfrost*.json; do
    [ -e "$f" ] || continue
    mv -f "$f" "$f$TAG"
done

echo "panvk-layer: active driver -> $TARGET"
