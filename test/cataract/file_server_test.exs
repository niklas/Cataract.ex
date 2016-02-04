defmodule Cataract.FileServerTest do
  use ExUnit.Case

  test "finding an existing file by exact name" do
    Cataract.FileServer.start_link(".")

    assert Cataract.FileServer.find_file("file_server_test.exs") == ["test/cataract/file_server_test.exs"]
  end

end
