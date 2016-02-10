defmodule Cataract.Repo.Migrations.AddSizeBytesToTorrents do
  use Ecto.Migration

  def change do
    alter table(:torrents) do
      add :size_bytes, :bigint
    end
  end
end
