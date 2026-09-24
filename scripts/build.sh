#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p .build
xcrun swiftc -swift-version 5 -O scripts/render-icon.swift -o .build/render-icon

build_app() {
    local source_name="$1" display_name="$2" icon_kind="$3"
    local app=".build/${display_name}.app"
    local iconset=".build/${source_name}.iconset"
    rm -rf "$app" "$iconset"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" "$iconset"
    xcrun swiftc -swift-version 5 -O Sources/ShortcutLauncher.swift "apps/${source_name}/main.swift" -o "$app/Contents/MacOS/${source_name}"
    cp "apps/${source_name}/Info.plist" "$app/Contents/Info.plist"
    .build/render-icon "$icon_kind" light "$iconset/icon_512x512@2x.png"
    for size in 16 32 128 256 512; do
        sips -s format png -Z "$size" "$iconset/icon_512x512@2x.png" --out "$iconset/icon_${size}x${size}.png" >/dev/null
        sips -s format png -Z "$((size * 2))" "$iconset/icon_512x512@2x.png" --out "$iconset/icon_${size}x${size}@2x.png" >/dev/null
    done
    iconutil -c icns "$iconset" -o "$app/Contents/Resources/AppIcon.icns"
    codesign --force --sign - "$app"
    codesign --verify --strict "$app"
    echo "Built $app"
}

build_app GoToFolder 前往路径 search
build_app GoUp 上一级 up
