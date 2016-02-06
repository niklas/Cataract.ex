defmodule Cataract.Repo.Migrations.CreateDisk do
  use Ecto.Migration

  def change do
    create table(:disks) do
      add :name, :string
      add :path, :string

      timestamps
    end

  end
end
