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
      [ "private_torrents private_torrents"                  , nil                              ] ,
      [ "torrents torrents"                                  , nil                              ] ,
      [ "CatPorn Archive/Very/Deeply/nested_on_disk/CatPorn" , "1 Torrent using 165.9 KiBytes"  ] ,
      [ "Incoming Incoming"                                  , "2 Torrents using 143.6 KiBytes" ] ,
    ] == find_list("ul.directories", "li", ["header", ".stats"])

    assert [
      [ "multiple" ],
      [ "single" ],
    ] == find_list("ul.directories li:last ul.torrents", "li", [".name"])


    # let's move a torrent without telling the library
    File.rename fs_root <> "/Incoming/tails.png",
                fs_root <> "/Archive/Very/tails.png"

    click({:link_text, "Index"})
    :timer.sleep(1000)

    # expecte for multiple to disappear, and single move to Archive/Very
    assert [
      [ "private_torrents private_torrents"                  , nil                              ] ,
      [ "torrents torrents"                                  , nil                              ] ,
      [ "CatPorn Archive/Very/Deeply/nested_on_disk/CatPorn" , "1 Torrent using 165.9 KiBytes"  ] ,
      [ "Incoming Incoming"                                  , nil                              ] ,
      [ "Very Archive/Very"                                  , "1 Torrent using 71.7 KiBytes"   ] ,
    ] == find_list("ul.directories", "li", ["header", ".stats"])

    File.rename fs_root <> "/Incoming/banane.poem",
                fs_root <> "/Archive/Very/banane.poem"

    click({:link_text, "Index"})
    :timer.sleep(1000)

    # expecte for multiple to reappear
    assert [
      [ "private_torrents private_torrents"                  , nil                              ] ,
      [ "torrents torrents"                                  , nil                              ] ,
      [ "CatPorn Archive/Very/Deeply/nested_on_disk/CatPorn" , "1 Torrent using 165.9 KiBytes"  ] ,
      [ "Incoming Incoming"                                  , nil                              ] ,
      [ "Very Archive/Very"                                  , "2 Torrents using 143.6 KiBytes" ] ,
    ] == find_list("ul.directories", "li", ["header", ".stats"])
  end
end
