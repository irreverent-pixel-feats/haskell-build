# haskell-ubuntu-xenial-build-8.0.2 [![Build Status](https://img.shields.io/travis/irreverent-pixel-feats/haskell-ubuntu-xenial-build-8.0.2.svg?style=flat)](https://travis-ci.org/irreverent-pixel-feats/haskell-ubuntu-xenial-build-8.0.2)

SHAs for tracking the build environment used to build your binaries can be found in
`/var/version`.

It differs from most other build images available on Docker in that it comes with
a pre-baked installation of [ambiata/mafia](https://github.org/ambiata/mafia) for those
who want an alternative to `stack`

Built images are available on [DockerHub](https://hub.docker.com/r/irreverentpixelfeats/haskell-build-ubuntu-xenial/)

Includes:

- `ghc v8.0.2`
- `cabal 1.24.0.2`
- `mafia`
