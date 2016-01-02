defmodule Cataract.TransferController do
  use Cataract.Web, :controller

  plug :fetch_transfers

  def index(conn, _p) do
    render(conn, "index.html")
  end

  def fetch_transfers(conn, _) do
    {:ok, tr } = Cataract.Rtorrent.find_all([:hash, :up_rate, :down_rate])
    assign conn, :transfers, tr
  end
end
