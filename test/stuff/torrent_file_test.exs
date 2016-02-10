defmodule Cataract.TorrentFileTest do
  use ExUnit.Case

  alias Cataract.TorrentFile

  test "extract metadata from torrent file" do
    fs_src  = Path.absname("./") <> "/test/fixtures/fs"

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/multiple.torrent") == %{
      size_bytes: 73451+128,
      info_hash: "594EF81CC61C94C1BCDB2CAFCF1E72B635DFF1B5",
      files: [
        %{ "path" => ["banane.poem"], "length" => 128 },
        %{ "path" => ["tails.png"],   "length" => 73451 },
      ],
    }

    assert TorrentFile.meta_from_file(fs_src <> "/Incoming/single.torrent") == %{
      size_bytes: 73451,
      info_hash: "AE596A610B269617E9163E69F82AFDACE20324DD",
      files: [
        %{ "path" => ["tails.png"],   "length" => 73451 },
      ],
    }
  end

  test "provides existance of files on disk" do
    fs_src  = Path.absname("./") <> "/test/fixtures/fs"
    fs_root = Path.absname("./") <> "/tmp/test_fs"

    torrent = fs_root <> "/Incoming/multiple.torrent"
    payload = fs_root <> "/Incoming/banane.poem"

    { _, 0 } = System.cmd "rsync", [
      "-a", "--delete",
      fs_src <> "/",
      fs_root <> "/",
    ]

    assert TorrentFile.payload_exists?( torrent, fs_root <> "/Incoming")
    # again
    assert TorrentFile.payload_exists?( torrent, fs_root <> "/Incoming")
    refute TorrentFile.payload_exists?( torrent, fs_root)

    # change the file size of one of the payload files
      File.open(payload, [:write, :append], fn (file) ->
        IO.write(file, "The End")
      end)

    # one file changed => not considered existing
    refute TorrentFile.payload_exists?( torrent, fs_root <> "/Incoming")
  end
end
