require Logger
defmodule Cataract.Library do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, "Lib"})
  end

  def index thingy  do
    Logger.debug("########## will index")
    GenServer.cast {:global, "Lib"}, {:index, thingy }
  end


  ### GenServer API

  # Cataract.Library.index(Cataract.Repo.get(Cataract.Disk, 2))

  def handle_cast({:index, %Cataract.Disk{} = disk}, status) do
    delay = 500
    Logger.debug("########## Indexing disk #{disk.path}")
    :timer.apply_after delay, Cataract.Endpoint, :broadcast!, [
      "directory:index", "create", %{data: %{
          id: 2342,
          attributes: %{name: "Incoming", path: "/foo/var"},
          relationships: %{
            disk: %{data: %{type: "disks", id: disk.id}},
          },
          type: "directories",
      }}
    ]
    {:noreply, status}
  end
end
