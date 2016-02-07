defmodule Cataract.Repo.Migrations.CreateDirectory do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :name, :string
      add :path, :string
      add :disk_id, references(:disks)
      add :parent_id, references(:directories)

      timestamps
    end
    create index(:directories, [:disk_id])
    create index(:directories, [:parent_id])

  end
end
