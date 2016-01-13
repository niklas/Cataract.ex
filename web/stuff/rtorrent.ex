defmodule Cataract.Rtorrent do
  def call(cmd, params \\ []) do
    url = String.to_char_list(System.get_env("RTORRENT_SOCKET") || "/home/niklas/rails/cataract/tmp/sockets/rtorrent_test")

    case :afunix.connect(url, []) do
      {:ok, socket} ->
        data = build_req(cmd, params)
        :ok = :afunix.send(socket, data)
        collect_response([])
      {:error, error} ->
        {:error, error} # FIXME unsure about how to handle "econnrefused"
    end
  end

  def find_all(fields \\ Cataract.Transfer.all_fields, view \\ "") do
    remote_fields = fields
                    |> Enum.map(&Atom.to_string/1)
                    |> Enum.map(fn (f) -> "d.get_" <> f <> "=" end)

    case Cataract.Rtorrent.call("d.multicall", List.insert_at(remote_fields, 0, view)) do
      {:ok, trs} ->
        {:ok,
        trs
          |> Enum.map(fn (tr) -> build_transfer(fields, tr) end)
        }
      {:error, error} ->
        {:error, error} # FIXME where should I catch this, repeat or show message to user?
    end
  end

  def remote_methods do
    {:ok, methods} = call("system.listMethods")
    methods
  end

  def build_transfer(fields, data) do
    struct( Cataract.Transfer,
      Enum.zip(fields,data)
      |> Enum.into( %{} )
    )
  end

  def build_req(cmd, params \\ []) do
    payload = %XMLRPC.MethodCall{method_name: cmd, params: params} |> XMLRPC.encode!
    h = %{
      "CONTENT_LENGTH" => (payload |> byte_size |> to_string),
      "SCGI"           => "1",
      "REQUEST_METHOD" => "POST",
      "REQUEST_URI"    => "/RPC2"
    }
    # SCGI headers are delimited by NULL byte
    headers = Map.keys(h)
      |> Enum.map(fn(k) -> k <> "\0" <> h[k] <> "\0" end)
      |> Enum.join()

    # netstring
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
    {:ok, param}
  end
end
