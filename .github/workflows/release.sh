#!/bin/bash
set -euxo pipefail
version=$(git rev-list --count HEAD).$(git rev-parse --short=12 HEAD)
alias curlu='curl -H "Authorization: Bearer $GITHUB_TOKEN"'
# TODO would be more legible with jo:
curlu -s -d '{"ref":"refs/tags/'$version'","sha":"'$GITHUB_SHA'"}' $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/git/refs
release=$(curlu -s $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/releases | jq -e -r '.[] | select(.draft == true and .name == "next") | .id')
curlu -X PATCH -d '{"draft":"false","name":"'$version'","tag_name":"'$version'"}' $GITHUB_API_URL/repos/$GITHUB_REPOSITORY/releases/$release
