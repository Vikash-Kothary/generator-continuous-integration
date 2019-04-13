#!/bin/bash
# file: git-change-author-info.sh

if [ ! -d .git ]; then
	echo 'Not a git repository'
	exit 1
fi

GIT_REPO=$(git config --get remote.origin.url)
#GIT_REPO=${GIT_REPO%????}
GIT_PROJECT_NAME=$(basename ${GIT_REPO})
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

cd /tmp
git clone --bare ${GIT_REPO}
cd ${GIT_PROJECT_NAME}
git filter-branch --env-filter '
OLD_EMAIL="kothary.vikash.work@gmail.com"
CORRECT_NAME="Vikash Kothary"
CORRECT_EMAIL="kothary.vikash@gmail.com"

if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
git push --force --tags origin 'refs/heads/*'
cd ..
rm -rf ${GIT_REPO}