defmodule Cataract.SetupLibraryTest do
  use Cataract.ConnCase

  # Import Hound helpers
  use Hound.Helpers
  import Cataract.HtmlHoundHelpers

  # Start a Hound session
  hound_session

  test "setup disks, finds torrents" do
    fs_src  = Path.absname("./") <> "/test/fixtures/fs"
    fs_root = Path.absname("./") <> "/tmp/test_fs"

    { _, 0 } = System.cmd "rsync", [
      "-a", "--delete",
      fs_src <> "/",
      fs_root <> "/",
    ]

    navigate_to "/ember"
    click({:link_text, "Library"})
    assert visible_in_page?(~r/Disks/)
    click({:link_text, "Register Disk"})
    fill_field({:name, "path"}, fs_root)
    click({:tag, "button"})

    :timer.sleep(1000)
    assert visible_in_page?(~r/#{fs_root}/), "Does not show path of created disk"
    assert visible_in_page?(~r/[^\/]test_fs/), "Does not show name of created disk"
    # wait for the indexers to run

    assert [
      [ "private_torrents" ,  nil           ,  nil                              ],
      [ "torrents"         ,  nil           ,  nil                              ],
      [ "CatPorn"          ,  "Torrents: 1" ,  "Accounted Space: 165.9 KiBytes" ],
      [ "Incoming"         ,  "Torrents: 2" ,  "Accounted Space: 143.6 KiBytes" ],
    ] == find_list(".directories", ["header", ".torrents_count", ".space"])
  end
end
