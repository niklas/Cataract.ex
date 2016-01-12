# How to deploy

  * MIX_ENV=prod mix phoenix.digest
  * MIX_ENV=prod PORT=4042 mix release
  + vagrant ssh -c 'cd PhoenixApp/ && mix hex.info'
  * vagrant ssh -c 'cd PhoenixApp/ && MIX_ENV=prod PORT=4042 mix release'
  * rsync -avP rel/cataract/releases/0.3.0/cataract.tar.gz torrents:elixir/

Test running the release (warning: production env)

  * PORT=4042 rel/cataract/bin/cataract console
