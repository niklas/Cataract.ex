defmodule Cataract.Repo.Migrations.AddPayloadDirectoryToTorrent do
  use Ecto.Migration

  def change do
    alter table(:torrents) do
      add :payload_directory_id, references(:directories)
    end
    create index(:torrents, [:payload_directory_id])
  end
end
