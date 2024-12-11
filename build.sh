#!/usr/bin/env bash

set -ex -o pipefail

if [ -z "$COREDNS_VERSION" ]; then
    # Get the latest release of coredns
    COREDNS_VERSION=$(curl --silent "https://api.github.com/repos/coredns/coredns/releases/latest" | jq -r .tag_name)
fi

# Download release tarball
curl -L -o coredns.tar "https://api.github.com/repos/coredns/coredns/tarball/$COREDNS_VERSION"

# Extract the tarball
tar -xf coredns.tar

cp plugin.cfg ./coredns-coredns-*/plugin.cfg

pushd coredns-coredns-*

make gen

SYSTEM="GOOS=linux GOARCH=amd64" BINARY="../dist/coredns-linux-amd64" make -e coredns
SYSTEM="GOOS=linux GOARCH=arm64" BINARY="../dist/coredns-linux-arm64" make -e coredns
