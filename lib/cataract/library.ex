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

  def later function, args do
    GenServer.cast {:global, "Lib"}, {:later, {function, args} }
  end


  ### GenServer API

  #  Library.later(:index, Cataract.Repo.get(Cataract.Disk, 2))
  # Cataract.Library.index(Cataract.Repo.get(Cataract.Disk, 2))

  def handle_cast({:index, %Cataract.Disk{} = disk}, status) do
    Logger.debug("########## Indexing disk #{disk.path}")
    Cataract.Endpoint.broadcast!(
      "directory:index", "create", %{data: %{
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

  def handle_cast({:later, {function, args}}, status) do
    delay = 500
    :timer.apply_after delay, __MODULE__, function, [args]
    {:noreply, status}
  end
end
