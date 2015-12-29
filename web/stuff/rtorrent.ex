defmodule Cataract.Rtorrent do
  def call(cmd, params \\ []) do
    url = '/home/niklas/rails/cataract/tmp/sockets/rtorrent_test'

    case :afunix.connect(url, []) do
      {:ok, socket} ->
        data = build_req(cmd, params)
        :ok = :afunix.send(socket, data)
        collect_response([])
      {:error, error} ->
        IO.puts error
    end
  end

  def build_req(cmd, params \\ []) do
    payload = %XMLRPC.MethodCall{method_name: cmd, params: params} |> XMLRPC.encode!
    h = %{
      "CONTENT_LENGTH" => (payload |> byte_size |> to_string),
      "SCGI"           => "1",
      "REQUEST_METHOD" => "POST",
      "REQUEST_URI"    => "/RPC2"
    }
    headers = Map.keys(h)
      |> Enum.map(fn(k) -> k <> "\0" <> h[k] <> "\0" end)
      |> Enum.join()

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
        |> String.replace(~r{\A.+?\r?\n\r?\n}s, "", global: false)
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

  def parse(nil) do
    IO.puts "empty response"
  end

  def parse(xml) do
    {:ok, %XMLRPC.MethodResponse{param: param} } = XMLRPC.decode(xml)
    param
    |> Enum.each(fn (e)-> IO.puts e end)
  end
end
