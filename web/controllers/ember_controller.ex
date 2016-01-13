defmodule Cataract.EmberController do
  use Cataract.Web, :controller

  def index(conn, _params) do
    conn
    |> put_layout("ember.html")
    |> render("index.html")
  end
end

