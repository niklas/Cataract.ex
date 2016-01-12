#!/bin/bash

set -e # stop on errors
set -x # echo on

export PORT=4042
export RTORRENT_SOCKET=/media/shared/rtorrent/socket
export MIX_ENV=prod

ln -sf ~/config/prod.secret.exs config/prod.secret.exs

########################################
# Build Ember App
########################################
cd ember

ember="node_modules/ember-cli/bin/ember"
bower="node_modules/bower/bin/bower"

npm install
[ -x $bower ] || npm install bower
$bower install
$ember build

cd -

########################################
# Build Phoenix App
########################################
[ -e ~/.mix/archives/hex-*.ez ] || mix local.hex --force
[ -e ~/.mix/rebar ]             || mix local.rebar --force
mix hex.info
mix deps.get
mix compile --force
brunch build --production
# mix ecto.migrate
mix phoenix.digest
