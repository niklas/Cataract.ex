#!/bin/bash

set -e # stop on errors

export PORT=4042
export RTORRENT_SOCKET=/media/shared/rtorrent/socket
export MIX_ENV=prod

# would confuse installation of afunix from git
unset GIT_DIR

# command shortcuts
app=rel/cataract/bin/cataract
ember="node_modules/ember-cli/bin/ember"
bower="node_modules/bower/bin/bower"


set -x # echo on

ln -sf ~/config/prod.secret.exs config/prod.secret.exs

########################################
# Build Ember App
########################################
cd ember

npm install
[ -x $bower ] || npm install bower
$bower install
$ember build --environment=production

cd -

########################################
# Build Phoenix App
########################################
[ -e ~/.mix/archives/hex-*.ez ] || mix local.hex --force
[ -e ~/.mix/rebar ]             || mix local.rebar --force
mix hex.info
mix deps.get
mix phoenix.digest
mix release --verbosity=verbose
# brunch build --production
# mix ecto.migrate

########################################
# Hot swap code
########################################
version="0.3.1"
$app upgrade $version
