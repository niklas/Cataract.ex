defmodule Cataract.TorrentFileTest do
  use ExUnit.Case

  alias Cataract.TorrentFile

  test "extract metadata from torrent file" do
    fs_src  = Path.absname("./") <> "/test/fixtures/fs"

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/multiple.torrent") == %{
      size_bytes: 73451+128,
      info_hash: "594EF81CC61C94C1BCDB2CAFCF1E72B635DFF1B5",
    }

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/single.torrent") == %{
      size_bytes: 73451,
      info_hash: "AE596A610B269617E9163E69F82AFDACE20324DD",
    }
  end
end
