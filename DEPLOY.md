# How to deploy

  * MIX_ENV=prod mix phoenix.digest
  * MIX_ENV=prod PORT=4042 mix release
  + vagrant ssh -c 'cd PhoenixApp/ && mix hex.info'
  * vagrant ssh -c 'cd PhoenixApp/ && MIX_ENV=prod PORT=4042 mix release'

Test running the release (warning: production env)

  * PORT=4042 rel/cataract/bin/cataract console
