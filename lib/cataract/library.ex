require Logger
defmodule Cataract.Library do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, "Lib"})
  end

  def index thingy  do
    GenServer.cast {:global, "Lib"}, {:index, thingy }
  end


  ### GenServer API

  def handle_cast({:index, %Cataract.Disk{} = disk}, status) do
    Logger.debug("########## Indexing disk #{disk.path}")

    Cataract.Endpoint.broadcast!("directory:index", "create",
      %{data: %{
          id: 2342,
          attributes: %{name: "Incoming", path: "/foo/var"},
          relationships: %{
            disk: %{data: %{type: "disks", id: disk.id}},
          },
          type: "directories",
      }}
    )
    {:noreply, status}
  end
end
