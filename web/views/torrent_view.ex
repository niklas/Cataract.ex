defmodule Cataract.TorrentView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :filename,
    :size_bytes,
    :info_hash,
  ]

  has_one :directory,
    serializer: Cataract.DirectoryView

  has_one :payload_directory,
    include: true,
    serializer: Cataract.DirectoryView

  def name(torrent, _conn) do
    torrent.filename
      |> String.replace(~r/\.torrent$/, "")
  end

  alias Cataract.Repo
  def preload(model) do
    model
      |> Repo.preload(payload_directory: :disk)
      |> Repo.preload(:directory)
  end
end

