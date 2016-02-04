defmodule Cataract.FileServer do
  def start_link(root) do
    db = "/tmp/cataract-fileserver.db"
    System.cmd "updatedb", [
      "--database-root", root,
      "--output", db,
      "--require-visibility", "no"
    ]
  end

  def find_file(filename) do
    db = "/tmp/cataract-fileserver.db"
    case System.cmd "locate", [
      "--database", db,
      "--basename",
      "--regexp",
      filename <> "$"
    ] do
      { out, 0 } ->
        String.split(out, "\n")
      { _, 1 } ->
        :nothing_found
    end
  end
end
