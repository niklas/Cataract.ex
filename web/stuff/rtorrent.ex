defmodule Cataract.Rtorrent do
  def call(cmd) do
    url = '/home/niklas/rails/cataract/tmp/sockets/rtorrent_test'

    case :afunix.connect(url, []) do
      {:ok, socket} ->
        data = build_req(cmd)
        :ok = :afunix.send(socket, data)
        collect_response([])
      {:error, error} ->
        IO.puts error
    end
  end

  def build_req(cmd) do
    null = "\0"
    # TODO escape / use  XMLRPC
    payload = "<?xml version=\"1.0\" ?><methodCall><methodName>" <> cmd <> "</methodName><params/></methodCall>" <> "\n"
    headers = "CONTENT_LENGTH" <> null <> (payload |> byte_size |> to_string) <> null <>
        "SCGI" <> null <> "1" <> null <>
        "REQUEST_METHOD" <> null <> "POST" <> null <>
        "REQUEST_URI" <> null <> "/RPC2" <> null
    (byte_size(headers) |> to_string) <> ":" <> headers <> "," <> payload
  end


  def collect_response(received) do
    receive do
      {:tcp, _s, resp} ->
        collect_response( [received, resp] )
      {:tcp_error, _s, err} ->
        IO.puts err
      {:tcp_closed, socket} ->
        received
        |> to_string
        |> String.split(~r{\r?\n\r?\n})
        |> Enum.at(1)
        |> parse
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
    {:ok, %XMLRPC.MethodResponse{param: param} } = XMLRPC.decode(xml)
    param
    |> Enum.each(fn (e)-> IO.puts e end)
  end
end
