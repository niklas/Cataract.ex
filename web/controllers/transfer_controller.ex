defmodule Cataract.TransferController do
  use Cataract.Web, :controller

  def index(conn, _p) do
    render(conn, "index.html")
  end
end
