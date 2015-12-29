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
    null = "\0"
    data = "64:" <>
    "CONTENT_LENGTH" <> null <> "100" <> null <>
    "SCGI" <> null <> "1" <> null <>
    "REQUEST_METHOD" <> null <> "POST" <> null <>
    "REQUEST_URI" <> null <> "/RPC2" <> null <>
    ",<?xml version=\"1.0\" ?><methodCall><methodName>system.listMethods</methodName><params/></methodCall>" <> "\n"
    :ok = :afunix.send(socket, data)
    receive do
      {:tcp, _s, resp} ->
        IO.puts "response:"
        IO.puts resp
      {:tcp_error, err} ->
        IO.puts err
      {a,b,c} ->
        IO.puts a
        IO.puts b
        IO.puts a
      Else ->
        IO.puts ".:"
    end
    :ok = :afunix.close(socket)
  end
end
