defmodule Cataract.FileServer do
  use GenServer

  ### Public API

  def start_link(root) do
    {:ok, pid} = :gen_server.start_link(__MODULE__, root, [])
    pid
  end

  def find_file(server, filename) do
    :gen_server.call server, {:find_file, filename}
  end

  ### Genserver API
  def init(root) do
    db = "/tmp/cataract-fileserver.db"
    root = Path.absname(root)
    System.cmd "updatedb", [
      "--database-root", root,
      "--output", db,
      "--require-visibility", "no"
    ]
    {:ok, %{root: root, db: db}}
  end

  def handle_call({:find_file, filename}, _from, status=%{db: db, root: root}) do
    case System.cmd "locate", [
      "--database", db,
      "--basename",
      "--regexp",
      filename <> "$"
    ] do
      { out, 0 } ->
        paths = out
        |> String.split("\n")
        |> Enum.reject( fn (line) -> line == "" end)
        |> Enum.map( fn (abs) -> Path.relative_to(abs, root) end)
        {:reply, paths, status}
      { _, 1 } ->
        {:reply, :not_found, status}
    end
  end
end
