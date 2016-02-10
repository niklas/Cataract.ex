defmodule Cataract.LibraryWorker do
  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Directory
  alias Cataract.Torrent

  import Ecto.Query, only: [from: 2]

  def torrent disk, path do
    parents = path |> Path.dirname |> Path.split
    ensure_path(disk, parents)
    |> ensure_torrent(disk.path <> "/" <> path)
  end

  ### Privates

  def ensure_path(disk, [root]) do
    query = from w in Directory,
            where: w.path == ^root
    case Repo.one(Directory.for_disk(query, disk)) do
      nil ->
        disk
          |> Ecto.build_assoc(:directories)
          |> Directory.changeset(%{path: root})
          |> Repo.insert!
          |> broadcast_create!
      directory ->
        broadcast_create!(directory)
        directory
    end
  end

  def ensure_torrent(directory, path) do
    filename = Path.basename(path)
    case Repo.one(from t in Torrent, where: t.filename == ^filename) do
      nil ->
        directory
          |> Ecto.build_assoc(:torrents)
          |> Torrent.changeset(%{filename: filename})
          |> Torrent.changeset(Cataract.TorrentFile.meta_from_file(path))
          |> Repo.insert!
          |> broadcast_create!
      torrent ->
        broadcast_create!(torrent)
        torrent
    end
  end

  def broadcast_create!(%Directory{} = directory) do
    directory
      |> Repo.preload(:disk)
      |> broadcast_create!("directory:index", Cataract.DirectoryView)
  end

  def broadcast_create!(%Torrent{} = torrent) do
    torrent
      |> Repo.preload(:directory)
      |> broadcast_create!("torrent:index", Cataract.TorrentView)
  end

  def broadcast_create!(record, topic, serializer) do
    jsonapi = serializer.format(record, %{})
    Cataract.Endpoint.broadcast!(topic, "create", jsonapi)
    record
  end
end
