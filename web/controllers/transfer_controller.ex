defmodule Cataract.TransferController do
  use Cataract.Web, :controller

  def index(conn, _p) do
    {:ok, transfers } = Cataract.Rtorrent.find_all([:hash, :up_rate, :down_rate])
    render conn, transfers: transfers
  end
end
