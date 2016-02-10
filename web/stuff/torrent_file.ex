defmodule Cataract.TorrentFile do
  def meta_from_file(file) do
    case file
      |> File.read!
      |> Bencode.decode do
        # single file
        {:ok, %{"info" => %{"length" => size} } } ->
          %{size_bytes: size}
        # multifile
        {:ok, %{"info" => %{"files" => files} } } ->
          size = files
            |> Enum.map(fn (f)-> f["length"] end)
            |> Enum.sum
          %{size_bytes: size}
        {:error, e } ->
          { :error, e }
      end
  end
end
