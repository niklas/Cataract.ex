defmodule Cataract.TransferController do
  use Cataract.Web, :controller

  def index(conn, _p) do
     case  Cataract.Rtorrent.find_all do
       {:ok, transfers } ->
         render conn, transfers: transfers
       { :error, error } ->
         conn
         |> put_status(503)
         |> text(error)
     end
  end
end
