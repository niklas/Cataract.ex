defmodule Cataract.LibraryWorker do
  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Directory

  import Ecto.Query, only: [from: 2]

  def torrent disk, path do
    parents = path |> Path.dirname |> Path.split
    name    = path |> Path.basename
    ensure_path(disk, parents)
  end

  ### Privates

  def ensure_path(disk, [root]) do
    Repo.preload disk, :directories
    query = from w in Directory,
            where: w.path == ^root
    case Repo.one(Directory.for_disk(query, disk)) do
      nil ->
        Cataract.Endpoint.broadcast!(
          "directory:index", "create", %{data: %{
              id: root,
              attributes: %{name: root, path: root},
              relationships: %{
                disk: %{data: %{type: "disks", id: disk.id}},
              },
              type: "directories",
          }}
        )
      directory -> directory
    end
  end
end
