#!/bin/bash
# file: git-project-update-remote.sh
# Update Local GH-Code, GH-Wiki and GH-Pages from Remote URLs and transfer files across

if [ ! -d .git ]; then
	echo 'Not a git repository'
	exit 1
fi

GIT_UPSTREAM_REPO=${1}
if [ -z ${GIT_UPSTREAM_REPO} ]; then
	GIT_UPSTREAM_REPO=https://github.com/shinesolutions/swagger-aem
fi


GIT_UPSTREAM_WIKI_EXISTS=$(git ls-remote --heads ${GIT_UPSTREAM_REPO}.wiki.git | wc -l)
if [ ${GIT_WIKI_EXISTS} == "0" ]; then
	echo "Upstream has not wiki page."
	exit 1
fi

git remote add upstream ${GIT_UPSTREAM_REPO}.git
git fetch upstream
git checkout master
git merge upstream/master

echo "${GIT_UPSTREAM_REPO}.wiki.git"

#git stash

#git checkout -b gh-pages
#git push --set-upstream upstream gh-pages