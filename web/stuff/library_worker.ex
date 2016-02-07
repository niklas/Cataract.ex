defmodule Cataract.LibraryWorker do
  require Logger
  def add_torrent file do
    name = Path.basename(file)
    Cataract.Endpoint.broadcast!(
      "directory:index", "create", %{data: %{
          id: file,
          attributes: %{name: name, path: file},
          relationships: %{
            disk: %{data: %{type: "disks", id: 1}},
          },
          type: "directories",
      }}
    )
  end
end
