defmodule Cataract.Rtorrent do
  def bla do
    url = '/home/niklas/rails/cataract/tmp/sockets/rtorrent_test'

    case :afunix.connect(url, []) do
      {:ok, _socket} ->
        IO.puts "connected"
      {:error, error} ->
        IO.puts error
    end
  end
end
