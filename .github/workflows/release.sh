#!/bin/bash
set -euxo pipefail
version=$(git rev-list --count HEAD).$(git rev-parse --short=12 HEAD)
# TODO would be more legible with jo:
curl -H "Authorization: Bearer $GITHUB_TOKEN" -s -d '{"ref":"refs/tags/'$version'","sha":"'$GITHUB_SHA'"}' $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/git/refs
release=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -s $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/releases | jq -e -r '.[] | select(.draft == true and .name == "next") | .id')
curl -H "Authorization: Bearer $GITHUB_TOKEN" -X PATCH -d '{"draft":"false","name":"'$version'","tag_name":"'$version'"}' $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/releases/$release
