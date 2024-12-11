#!/usr/bin/env bash

set -ex -o pipefail

if [ -z "$COREDNS_VERSION" ]; then
    # Get the latest release of coredns
    COREDNS_VERSION=$(curl --silent "https://api.github.com/repos/coredns/coredns/releases/latest" | jq -r .tag_name | sed 's/^v//')
fi

# Download release tarball
curl -L -o coredns.tar "https://api.github.com/repos/coredns/coredns/tarball/v$COREDNS_VERSION"


# Extract the tarball
tar -xf coredns.tar

pushd coredns-coredns-*

cat plugin.cfg ../plugin.cfg > plugin.cfg.tmp
mv plugin.cfg.tmp plugin.cfg

make gen

SYSTEM="GOOS=linux GOARCH=amd64" BINARY="../dist/coredns-linux-amd64" make -e coredns
SYSTEM="GOOS=linux GOARCH=arm64" BINARY="../dist/coredns-linux-arm64" make -e coredns
