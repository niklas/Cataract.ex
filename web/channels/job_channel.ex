defmodule Cataract.JobChannel do
  use Phoenix.Channel

  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Library

  def join("job:index", message, socket) do
    {:ok, socket}
  end

  def handle_in("index_disk", id, socket) do
    Disk
      |> Repo.get(id)
      |> Library.index!
    {:noreply, socket}
  end
end


