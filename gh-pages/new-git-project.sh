#!/bin/bash
# file: new-git-project.sh
# TODO: Migrate to multirepo support e.g. gitlab, bitbucket, etc
# TODO: Add multiple CI support

if [ ! -d .git ]; then
	echo 'Not a git repository'
	exit 1
fi

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$GIT_BRANCH" != "master" ]]; then
	echo 'Must be run on a master branch';
	exit 1;
fi

# Set upstream?
GIT_REPO=${1}
if [ -z GIT_REPO ]; then
	GIT_REPO=$(git config --get remote.origin.url)
fi

GIT_WIKI_EXISTS=$(git ls-remote --heads ${GIT_REPO}.wiki.git | wc -l)
if [ ${GIT_WIKI_EXISTS} == "0" ]; then
	echo "Please create a wiki page first."
	exit 1
fi

git stash

# Git flow
# TODO: Initialise GH Wiki
git checkout -b gh-pages
git push --set-upstream origin gh-pages
# TODO: replace with `git flow init`
git checkout -b develop
git push --set-upstream origin develop

# Git subrepos
# TODO: CI Deploy from master
git subrepo clone ${GIT_REPO}.git gh-pages -b gh-pages
git commit --amend -m "Add gh-pages folder"
git subrepo clone ${GIT_REPO}.wiki.git gh-wiki
git commit --amend -m "Add gh-wiki folder"

touch .gitignore .travis.yml
mkdir .github .github/ISSUE_TEMPLATE

# Open Source Docs Generator
touch README.md \
	LICENSE \
	.github/ISSUE_TEMPLATE.md \
	.github/PULL_REQUEST.md \
	.github/ISSUE_TEMPLATE/BREAKING_CHANGE_TEMPLATE.md \
	.github/ISSUE_TEMPLATE/BUG_REPORT_TEMPLATE.md \
	.github/ISSUE_TEMPLATE/FEATURE_REQUEST_TEMPLATE.md \
	.github/ISSUE_TEMPLATE/OTHER_ISSUE_TEMPLATE.md 

pushd gh-wiki
touch CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md
popd

pushd gh-pages
# TODO: Create boilerplate app e.g. HTML5 Boilerplate or `npx create-react-app`
popd

git add --all
git commit -m "Add open source documentation boilerplate"


git stash pop

