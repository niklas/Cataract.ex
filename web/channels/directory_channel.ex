defmodule Cataract.DirectoryChannel do
  use Phoenix.Channel
  require Logger

  alias Cataract.Directory
  alias Cataract.Repo

  def join("directory:index", message, socket) do
    Logger.debug "=== join #{socket.topic}"
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def handle_info({:after_join, _msg}, socket) do
    push socket, "create", %{data: %{
        id: 2342,
        attributes: %{name: "Incoming", path: "/foo/var"},
        relationships: %{
          disk: %{data: %{type: "disks", id: "2"}},
        },
        type: "directories",
      }}
    {:noreply, socket}
  end
end

