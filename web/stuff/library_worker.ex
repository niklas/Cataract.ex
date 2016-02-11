require Logger
defmodule Cataract.LibraryWorker do
  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Directory
  alias Cataract.Torrent
  alias Cataract.Library
  alias Cataract.TorrentFile
  alias Cataract.FileServer

  import Ecto.Query, only: [from: 2]

  def torrent disk, path do
    parents = path |> Path.dirname |> Path.split
    ensure_path(disk, parents)
    |> ensure_torrent(disk.path <> "/" <> path)
  end

  # verify if payload is still there, else => set nil
  def verify_payload!(torrent) do
    Logger.debug("########## Verifying payload for #{torrent.filename}")
    torrent
  end

  # search for payload on all disks
  # assign first directory with full content as payload_directory
  def find_payload!(torrent, sources) do
    %{files: [%{"path" => first_file} |_rest]} = meta = TorrentFile.meta(torrent)

    # Stream?
    sources
    |> Enum.find( fn({disk, index})->
      Logger.debug ">>>>>> searching #{first_file} on #{disk.path} [#{inspect index}]"
      index
      |> FileServer.find_file(Path.join first_file)
      |> Enum.find( fn(cand)->
        from_disk = Path.dirname(cand)
        absolute = Path.join( disk.path, from_disk)
        Logger.debug "??????? maybe #{cand} at #{absolute}"
        if TorrentFile.payload_exists?(meta, absolute) do
          Logger.debug "!!!!!!! found #{absolute}"
          dir = ensure_path(disk, Path.split(from_disk))
          torrent
          |> Torrent.update_payload_directory!(dir)
          |> broadcast_update!
        end
      end)
    end)

    torrent
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
          |> Torrent.changeset(TorrentFile.meta(path))
          |> Repo.insert!
      torrent ->
        torrent
    end
      |> Library.index!
      |> broadcast_create!
  end

  def broadcast_create!(%Directory{} = directory) do
    directory
      |> Repo.preload(:disk)
      |> broadcast_create!("directory:index", Cataract.DirectoryView)
  end

  def broadcast_create!(%Torrent{} = torrent) do
    torrent
      |> Repo.preload(:directory)
      |> Repo.preload(:payload_directory)
      |> broadcast_create!("torrent:index", Cataract.TorrentView)
  end

  def broadcast_create!(record, topic, serializer) do
    jsonapi = serializer.format(record, %{})
    Logger.debug "broadcasting to #{topic}: #{inspect jsonapi}"
    Cataract.Endpoint.broadcast!(topic, "create", jsonapi)
    record
  end

  # actually update
  def broadcast_update!(thingy) do
    broadcast_create!(thingy)
  end
end
