require Logger
defmodule Cataract.Library do
  use GenServer
  alias Cataract.FileServer
  alias Cataract.Repo
  alias Cataract.Disk
  alias Cataract.Torrent
  alias Cataract.LibraryWorker, as: Worker

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: {:global, "Lib"})
  end

  def index thingy  do
    GenServer.cast {:global, "Lib"}, {:index, thingy }
  end

  @spec index!(Ecto.Model.t) :: Ecto.Model.t

  def index! thingy do
    :ok = index thingy
    thingy
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

  def handle_cast({:index, %Disk{} = disk}, status) do
    Logger.debug("########## Indexing disk #{disk.path}")
    file_server(status, disk.path)
      |> FileServer.find_file_with_extension("torrent")
      |> Enum.each(fn (p) -> Worker.torrent(disk, p) end)
    {:noreply, status}
  end

  def handle_cast({:index, %Torrent{} = torrent}, status) do
    torrent = Repo.preload(torrent, [ :payload_directory, [directory: :disk] ])
    if torrent.payload_directory do
      Logger.debug("########## pd #{torrent.payload_directory}")
      Worker.verify_payload!(torrent)
    else
      Logger.debug("########## Finding payload for #{torrent.filename}")
      sources = Disk
        |> Repo.all
        |> Enum.map( fn(d)-> {d, file_server(status, d.path)} end)
      Worker.find_payload!(torrent, sources)
    end
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
