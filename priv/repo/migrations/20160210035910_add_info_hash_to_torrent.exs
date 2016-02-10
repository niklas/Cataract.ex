defmodule Cataract.Repo.Migrations.AddInfoHashToTorrent do
  use Ecto.Migration

  def change do
    alter table(:torrents) do
      add :info_hash, :string, size: 40
    end
  end
end
