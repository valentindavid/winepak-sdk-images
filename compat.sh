#!/bin/sh

set -e

VERSION="$1"

flatpak remote-add --user winepak-local winepak-repo --no-gpg-verify --if-not-exists

flatpak install --user winepak-local --arch=i386 --reinstall "runtime/org.winepak.Platform//${VERSION}"

rm -rf compat
flatpak build-init compat org.winepak.Platform.Compat.i386 org.winepak.Platform/i386 org.winepak.Platform/i386 --type=extension --writable-sdk "${VERSION}"

flatpak build-finish --sdk="org.winepak.Sdk/x86_64/${VERSION}" --runtime="org.winepak.Platform/x86_64/${VERSION}" --metadata=ExtensionOf=ref="runtime/org.winepak.Platform/x86_64/${VERSION}" compat

flatpak build-export winepak-repo compat --files=usr/lib/i386-linux-gnu --arch=x86_64 "${VERSION}"
