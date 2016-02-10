defmodule Cataract.TorrentFile do
  def meta_from_file(file) do
    case file
      |> File.read!
      |> Bencode.decode do
        # single file
        {:ok, %{"info" => info = %{"length" => size} } } ->
          %{size_bytes: size, info_hash: hash_from_info(info)}
        # multifile
        {:ok, %{"info" => info = %{"files" => files} } } ->
          size = files
            |> Enum.map(fn (f)-> f["length"] end)
            |> Enum.sum
          %{size_bytes: size, info_hash: hash_from_info(info)}
        {:error, e } ->
          { :error, e }
      end
  end

  def hash_from_info(info) do
    :crypto.hash(:sha, Bencode.encode!(info))
      |> Base.encode16
  end
end
