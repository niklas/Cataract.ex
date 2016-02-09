defmodule Cataract.TorrentChannel do
  use Phoenix.Channel

  def join("torrent:index", message, socket) do
    {:ok, socket}
  end
end

