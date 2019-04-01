#!/bin/bash
# file: release-git-project.sh

if [ ! -d .git ]; then
	echo 'Not a git repository'
	exit 1
fi

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$GIT_BRANCH" != "master" ]]; then
	echo 'Must be run on a master branch';
	exit 1;
fi

VERSION=${1}
if [ -z ${VERSION} ]; then
	echo "A new version must be specified."
	exit 1
fi

# Stash any uncommitted chanages
git stash
# Ensure subrepos are up-to-date
git subrepo clean gh-wiki
git subrepo clean gh-pages
# Ensure subrepos are up-to-date
git subrepo pull gh-wiki
git subrepo pull gh-pages
# Create release branch from master
git checkout -b release/${VERSION} master
# Pushing changes
git subrepo push gh-wiki
# TODO: Check if push commit was made
# git commit --amend -m "release/gh-wiki-${VERSION}"
git subrepo push gh-pages
# TODO: Check if push commit was made
# git commit --amend -m "release/gh-pages-${VERSION}"

git checkout master
git merge --no-ff release/${VERSION} -m "Merge branch release/${VERSION}"
git tag ${VERSION}
git push
git push --tags
git branch -d release/${VERSION}
# Update develop
git checkout develop
git merge master
git push
# Return any uncommitted changes
git stash pop