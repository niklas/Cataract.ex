defmodule Cataract.Rtorrent do
  def bla do
    url = '/home/niklas/rails/cataract/tmp/sockets/rtorrent_test'

    case :afunix.connect(url, []) do
      {:ok, socket} ->
        IO.puts "connected"
        null = "\0"
        data = "64:" <>
        "CONTENT_LENGTH" <> null <> "100" <> null <>
        "SCGI" <> null <> "1" <> null <>
        "REQUEST_METHOD" <> null <> "POST" <> null <>
        "REQUEST_URI" <> null <> "/RPC2" <> null <>
        ",<?xml version=\"1.0\" ?><methodCall><methodName>system.listMethods</methodName><params/></methodCall>" <> "\n"
        :ok = :afunix.send(socket, data)
        collect_response([])
      {:error, error} ->
        IO.puts error
    end
  end

  def collect_response(received) do
    receive do
      {:tcp, _s, resp} ->
        IO.puts "response"
        collect_response( [received, resp] )
      {:tcp_error, _s, err} ->
        IO.puts err
      {:tcp_closed, socket} ->
        received
        |> to_string
        |> String.split("\n\n")
        |> List.first
        |> String.slice(0,200)
        |> IO.puts
        IO.puts "done."
        :ok = :afunix.close(socket)
      {a,b,c} ->
        IO.puts "WTF:"
        IO.puts a
        IO.puts b
        IO.puts a
      Else ->
        IO.puts ".:"
    end
  end

  def parse(xml) do
    xml
    |> XMLRPC.decode
    |> IO.puts
  end
end
