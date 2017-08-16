GIT_VERSION = 2.13.2
GHC_VERSION = 8.0.2
GMP_VERSION = 4.3.2
CABAL_VERSION = 1.24.0.2
PWD = $(shell pwd)
REPO = irreverentpixelfeats/haskell-build-ubuntu-xenial
BASE_TAG = ${GHC_VERSION}

tars/git-${GIT_VERSION}.tar.gz:
	cd lib/src && (tar czvf ${PWD}/tars/git-${GIT_VERSION}.tar.gz git-${GIT_VERSION} > /dev/null)

tars/mafia: lib/src/mafia/mafia
	cp -v lib/src/mafia/mafia tars/

git-sha:
	bin/git-version ./latest-version
	diff -q latest-version data/version || cp -v latest-version data/version
	rm latest-version

deps: git-sha tars/mafia tars/git-${GIT_VERSION}.tar.gz

build: deps Dockerfile
	docker pull "${REPO}:${BASE_TAG}" || true
	docker build --cache-from "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}" --tag "${REPO}:${BASE_TAG}-$(shell cat data/version)" .

images/haskell-build-ubuntu-xenial-${BASE_TAG}.tar.gz: build
	docker image save -o images/haskell-build-ubuntu-xenial-${BASE_TAG}.tar ${REPO}:${BASE_TAG}
	cd images && gzip -v haskell-build-ubuntu-xenial-${BASE_TAG}.tar

image: images/haskell-build-ubuntu-xenial-${BASE_TAG}.tar.gz

all: build image
