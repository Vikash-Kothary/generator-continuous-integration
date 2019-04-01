#!make
#@ Makefile for Travis CI

# include .env
# export

#@ Commands:
#@ - help: Show all commands.
help:
	@fgrep -h "#@" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/#@ //'

dependancies:
	git clone https://github.com/ingydotnet/git-subrepo /tmp/git-subrepo
	echo 'source /path/to/git-subrepo/.rc' >> ~/.bashrc


git-config:
	git config --global user.name "Travis CI"
	git config --global user.email "travis@travis-ci.org"

release:
	# Ensure version is provided
	@test ${VERSION}
	# Stash any uncommitted chanages
	git stash
	# Ensure subrepos are up-to-date
	git subrepo pull gh-wiki
	git subrepo pull gh-pages
	# Create release branch from master
	git checkout -b release/${VERSION} master
	# Pushing changes
	git subrepo push gh-wiki
	git commit --amend -m "release/gh-wiki-${VERSION}"
	git subrepo push gh-pages
	git commit --amend -m "release/gh-pages-${VERSION}"

	git checkout master
	git merge --no-ff release/${VERSION} -m "Merge branch release/${VERSION}"
	git tag ${VERSION}
	git push
	git push --tags
	git branch -d release/${VERSION}
	# Update develop
	git checkout -b develop
	git merge master
	git push
	# Return any uncommitted changes
	git stash pop
