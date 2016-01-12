#!/bin/bash

set -e # stop on errors
set -x # echo on

export PORT=4042
export RTORRENT_SOCKET=/media/shared/rtorrent/socket
export MIX_ENV=prod

cp ~/config/prod.secret.exs config/prod.secret.exs

[ -e ~/.mix/archives/hex-*.ez ] || mix local.hex --force
[ -e ~/.mix/rebar ]             || mix local.rebar --force
mix hex.info
mix deps.get
mix compile --force
mix phoenix.digest
