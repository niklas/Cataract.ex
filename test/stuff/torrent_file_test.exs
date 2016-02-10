defmodule Cataract.TorrentFileTest do
  use ExUnit.Case

  alias Cataract.TorrentFile

  test "extract metadata from torrent file" do
    fs_src  = Path.absname("./") <> "/test/fixtures/fs"

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/multiple.torrent") == %{
      size_bytes: 73451+128
    }

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/single.torrent") == %{
      size_bytes: 73451
    }
  end
end
