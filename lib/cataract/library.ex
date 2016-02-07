require Logger
defmodule Cataract.Library do
  use GenServer
  alias Cataract.FileServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: {:global, "Lib"})
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
  def init(status) do
    status = Map.put( status, :file_servers, %{} )
    { :ok, status }
  end

  def handle_cast({:index, %Cataract.Disk{} = disk}, status) do
    Logger.debug("########## Indexing disk #{disk.path}")
    file_server(status, disk.path)
      |> FileServer.find_file_with_extension("torrent")
      |> Enum.each(&Cataract.LibraryWorker.add_torrent/1)
    {:noreply, status}
  end

  def handle_cast({:later, {function, args}}, status) do
    delay = 500
    :timer.apply_after delay, __MODULE__, function, [args]
    {:noreply, status}
  end

  def file_server(%{file_servers: list} = status, path) do
    case Map.get(list, path) do
      nil    ->
        server = FileServer.start_link(path)
        Map.put(list, path, server)
        server
      server -> server
    end
  end

end
