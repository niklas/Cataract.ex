defmodule Cataract.Rtorrent do
  def bla do
    url = '/home/niklas/rails/cataract/tmp/sockets/rtorrent_test'

    case :afunix.connect(url, []) do
      {:ok, socket} ->
        IO.puts "connected"
        ping socket
      {:error, error} ->
        IO.puts error
    end
  end

  def ping(socket) do
    data = '12345678'
    :ok = :afunix.send(socket, data)
    case :afunix.recv(socket, 1000, 10) do
      {:ok, resp} ->
        IO.puts "response:"
        IO.puts resp
      {:error, err} ->
        IO.puts "error"
        IO.puts err
    end
  end
end
