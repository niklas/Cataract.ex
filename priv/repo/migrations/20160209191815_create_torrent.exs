defmodule Cataract.Repo.Migrations.CreateTorrent do
  use Ecto.Migration

  def change do
    create table(:torrents) do
      add :name, :string
      add :filename, :string
      add :directory_id, references(:directories)

      timestamps
    end
    create index(:torrents, [:directory_id])

  end
end
