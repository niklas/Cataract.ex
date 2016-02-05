defmodule Cataract.FileServerTest do
  use ExUnit.Case

  alias Cataract.FileServer

  setup do
    server = FileServer.start_link("./")
    {:ok, [server: server]}
  end

  test "finds an existing file by exact name", %{server: server} do
    assert FileServer.find_file(server, "file_server_test.exs") == ["test/cataract/file_server_test.exs"]
  end

  test "does not find a nonexisting file by exact name", %{server: server} do
    assert FileServer.find_file(server, "CodeOfConduct.doc") == :not_found
  end

  test "finds existing file by extension", %{server: server} do
    assert Enum.member?( Cataract.FileServer.find_file_with_extension(server, "exs") , "test/cataract/file_server_test.exs" )
  end

  test "does not find nonexisting file by extension", %{server: server} do
    assert FileServer.find_file_with_extension(server, "php") == :not_found
  end
end
