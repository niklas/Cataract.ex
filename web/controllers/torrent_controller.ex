defmodule Cataract.TorrentController do
  use Cataract.Web, :controller

  alias Cataract.Repo
  alias Cataract.Torrent
  alias Cataract.Directory

  import Ecto.Query, only: [from: 2]

  def index conn, %{"disk" => disk_id} do
    query = from t in Torrent,
      join: dir in Directory, on: dir.id == t.payload_directory_id,
      where: dir.disk_id == ^disk_id
    torrents = query
      |> Repo.all
      |> Cataract.TorrentView.preload
    render conn, model: torrents
  end
end
