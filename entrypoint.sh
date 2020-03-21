#!/bin/sh -l

set -e

INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_TAGS=${INPUT_TAGS:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
_FORCE_OPTION=''
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "❯ Configure:";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

if ${TAGS}; then
    _TAGS='--tags'
fi

cd ${INPUT_DIRECTORY}

git config --global user.email "me@ahmadawais.com"
git config --global user.name "Ahmad Awais"

REMOTE_REPO="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

git clone "${REMOTE_REPO}" .
npx auto-changelog
git add .
git commit -m " 📖 DOC: Changelog"

git push "${REMOTE_REPO}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION $_TAGS;
