defmodule Cataract.DiskController do
  use Cataract.Web, :controller

  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Library

  def index conn, _params do
    render conn, model: Repo.all(Disk)
  end

  def show conn, %{"id" => id} do
    render conn, model: Repo.get(Disk, id)
  end

  def create conn, %{"attributes" => params} do
    changeset = Disk.changeset(%Disk{}, params)

    case Repo.insert(changeset) do
      {:ok, disk} ->
        Library.later(:index, disk)
        conn
        |> put_status(201)
        |> render(:show, data: disk)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(:errors, data: changeset)
    end
  end
end
