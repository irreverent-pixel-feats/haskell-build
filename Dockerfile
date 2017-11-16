FROM ubuntu:xenial
MAINTAINER Dom De Re <domdere@irreverentpixelfeats.com>

ENV GHC_VERSION=8.0.2
ENV GIT_VERSION=2.13.2
ENV CABAL_VER=1.24

#ADD git-${GIT_VERSION}/* /tmp/git/
#ADD gmp-${GMP_VERSION}/* /tmp/gmp/
#ADD ghc-${GHC_VERSION}/* /tmp/ghc/
#ADD cabal-install-${CABAL_VER}/* /tmp/cabal-install/

# Do the downloading first:

## deps
RUN apt-get update -y \
  && apt-get install -y software-properties-common autoconf automake build-essential libtool make gcc g++ libgmp-dev ncurses-dev libtinfo-dev python3 xz-utils dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev ssh
RUN apt-add-repository -y "ppa:hvr/ghc" && apt-get update -y
RUN apt-get install -y ghc-${GHC_VERSION} cabal-install-${CABAL_VER}
RUN ln -sf /opt/ghc/bin/* /usr/local/bin
RUN ln -sf /opt/cabal/bin/* /usr/local/bin
RUN cabal update

# END ghc shortcut

ADD tars tmp

RUN cd /tmp \
  && (tar xzvf git-${GIT_VERSION}.tar.gz > /dev/null) \
  && cd /tmp/git-${GIT_VERSION} \
  && (find . -type f | grep "/\._" | while read F; do rm -rfv ${F}; done) \
  && make configure \
  && ./configure --prefix /opt/git/${GIT_VERSION} \
  && make all -j \
  && make install \
  && ln -sf /opt/git/${GIT_VERSION}/bin/* /usr/local/bin

# "install" mafia bootstrap script for repos that dont include it
# And prime it.
ENV MAFIA_VERSION=08d64c797eb2ad9af7afdd747db3111e540bd67b
RUN mkdir -p /opt/mafia && cp -v /tmp/mafia /opt/mafia/mafia && /opt/mafia/mafia upgrade ${MAFIA_VERSION}

# stuff in the data dir is likely to change very frequently but doesnt actually affect the image much itself,
# example: version SHAs
# So adding it last should speed up the builds
ADD data /tmp

# Add the git-sha for the docker file to the image so if you need you can see where
# your image sat in the timeline of git changes (which might be tricky to correlate with the
# docker hub changes)
RUN mkdir -p /var/versions && cp -v /tmp/version /var/versions/haskell-build-ubuntu-xenial-8.0.2.version

RUN cd /tmp && rm -rf /tmp/*
