defmodule Cataract.DiskChannel do
  use Phoenix.Channel
  require Logger

  alias Cataract.Disk
  alias Cataract.Repo

  def join("disk:create", _message, socket) do
    Logger.debug "=== join #{socket.topic}"

    {:ok, socket}
  end

  def handle_in("create", %{"disk" => params}, socket) do
    changeset = Disk.changeset(%Disk{}, params)

    case Repo.insert(changeset) do
      {:ok, disk} ->
        {:reply, { :ok, disk }, socket }
      {:error, changeset} ->
        # TODO: validation errors are not shown
        {:reply, { :error, Enum.into(changeset.errors, %{})}, socket }
    end
  end
end
