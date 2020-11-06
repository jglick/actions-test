#!/bin/bash
set -euxo pipefail
version=$(git rev-list --count HEAD).$(git rev-parse --short=12 HEAD)
echo "::set-output name=version::$version"
# TODO would be more legible with jo:
curl -H "Authorization: Bearer $GITHUB_TOKEN" -s -d '{"ref":"refs/tags/'$version'","sha":"'$GITHUB_SHA'"}' $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/git/refs
