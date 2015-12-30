defmodule Cataract.TransferController do
  use Cataract.Web, :controller

  plug :fetch_transfers

  def index(conn, _p) do
    render(conn, "index.html")
  end

  def fetch_transfers(conn, _) do
    {:ok, tr } = Cataract.Rtorrent.call("d.multicall", ["", "d.get_hash=", "d.get_up_rate=", "d.get_down_rate="])
    assign conn, :transfers, tr
  end
end
