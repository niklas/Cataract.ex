defmodule Cataract.PageController do
  use Cataract.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
