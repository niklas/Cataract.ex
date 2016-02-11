defmodule Cataract.TorrentFile do
  alias Cataract.Torrent, as: T

  def meta(%T{} = torrent) do
    meta T.absolute_file_path(torrent)
  end

  def meta(%{} = already) do
    already
  end

  def meta(file) do
    case decode_file(file) do
        # single file
        {:ok, %{"info" => info = %{"length" => size, "name" => name} } } ->
          files = []
          %{
            size_bytes: size,
            info_hash:  hash_from_info(info),
            files:      [%{"length" => size, "path" => [name]}],
          }
        # multifile
        {:ok, %{"info" => info = %{"files" => files} } } ->
          size = files
            |> Enum.map(fn (f)-> f["length"] end)
            |> Enum.sum
          %{
            size_bytes: size,
            info_hash:  hash_from_info(info),
            files:      files,
          }
        {:error, e } ->
          { :error, e }
      end
  end

  def payload_exists?(torrent_path, payload_path) do
    case meta(torrent_path) do
      %{files: files} ->
        files
          |> Enum.map( fn (%{"path" => f, "length" => s})->
            { Path.join(payload_path, f), s }
          end)
          |> Enum.all?( fn ({p,size})->
            case File.stat(p) do
              {:ok, %File.Stat{size: size_on_disk}} ->
                size_on_disk == size
              {:error, _ } ->
                false
            end
          end)
      _ -> false
    end
  end

  ### Utilities

  def decode_file(file) do
    file
      |> File.read!
      |> Bencode.decode
  end

  def hash_from_info(info) do
    :crypto.hash(:sha, Bencode.encode!(info))
      |> Base.encode16
  end
end
