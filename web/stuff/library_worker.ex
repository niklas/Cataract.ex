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
    query = from w in Directory,
            where: w.path == ^root
    case Repo.one(Directory.for_disk(query, disk)) do
      nil ->
        directory = disk
          |> Ecto.build_assoc(:directories)
          |> Directory.changeset(%{path: root})
          |> Repo.insert!
        broadcast_create!(directory)
        directory
      directory ->
        broadcast_create!(directory)
        directory
    end
  end

  def broadcast_create!(record) do
    topic = "directory:index"
    conn = %{}
    record = Repo.preload record, :disk
    jsonapi = Cataract.DirectoryView.format(record, conn)
    Cataract.Endpoint.broadcast!(topic, "create", jsonapi)
  end
end
