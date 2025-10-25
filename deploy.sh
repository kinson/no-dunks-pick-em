source .env
export MIX_ENV=prod

echo "Stopping application"
_build/prod/rel/no_dunks_pick_em/bin/no_dunks_pick_em stop

echo "Fetching latest deps"
mix deps.get --only prod

echo "Building application"
mix assets.deploy
mix release --overwrite

echo "Migrating"
mix ecto.migrate

echo "Starting application"
_build/prod/rel/no_dunks_pick_em/bin/no_dunks_pick_em daemon
