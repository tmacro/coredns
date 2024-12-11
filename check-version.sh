#!/usr/bin/env bash

set -ex -o pipefail

COREDNS_VERSION=$(curl --silent "https://api.github.com/repos/coredns/coredns/releases/latest" | jq -r .tag_name)
REPO_VERSION=$(curl --silent "https://api.github.com/repos/$BUILD_REPO/releases/latest" | jq -r .name)

if [ "$COREDNS_VERSION" == "$REPO_VERSION" ]; then
    echo "Repository release matches latest CoreDNS release"
else
    echo "Repository release does not match latest CoreDNS release"
    echo "CoreDNS: $COREDNS_VERSION"
    echo "Repository: $REPO_VERSION"
    exit 1
fi
