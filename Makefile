GIT_VERSION = 2.13.2
GHC_VERSION = 8.0.2
GMP_VERSION = 4.3.2
CABAL_VERSION = 1.24.0.2
PWD = $(shell pwd)

tars/git-${GIT_VERSION}.tar.gz:
	cd lib/src && (tar czvf ${PWD}/tars/git-${GIT_VERSION}.tar.gz git-${GIT_VERSION} > /dev/null)

tars/mafia: lib/src/mafia/mafia
	cp -v lib/src/mafia/mafia tars/

git-sha:
	bin/git-version ./latest-version
	diff -q latest-version tars/version || cp -v latest-version tars/version
	rm latest-version

deps: git-sha tars/mafia tars/git-${GIT_VERSION}.tar.gz

build: deps Dockerfile
	docker build --tag irreverentpixelfeats/haskell-build-ubuntu-xenial:8.0.2 .
	docker build --tag irreverentpixelfeats/haskell-build-ubuntu-xenial:8.0.2-$(shell cat tars/version) .

../../images/haskell-build-ubuntu-xenial-8.0.2.tar.gz: build
	docker image save -o ../../images/haskell-build-ubuntu-xenial-8.0.2.tar irreverentpixelfeats/haskell-build-ubuntu-xenial:8.0.2
	cd ../../images && gzip -v haskell-build-ubuntu-xenial-8.0.2.tar

image: ../../images/haskell-build-ubuntu-xenial-8.0.2.tar.gz

all: build image
