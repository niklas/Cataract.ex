defmodule Cataract.SetupLibraryTest do
  use Cataract.ConnCase

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session

  test "setup disks, finds torrents" do
    fs_root = Path.absname("./") <> "/tmp/test_fs"

    navigate_to "/ember"
    click({:link_text, "Library"})
    assert visible_in_page?(~r/Disks/)
    click({:link_text, "Register Disk"})
    fill_field({:name, "path"}, fs_root)
    submit_element({:link_text, "Register"})

    assert visible_in_page?(~r/test_fs/)
    # wait for the indexers to run
    :timer.sleep(1000)
    assert visible_in_page?(~r/Incoming/), "Imports and shows Directory"
    assert visible_in_page?(~r/Torrents: 2/), "Imports and show number of torrents"
    assert visible_in_page?(~r/Accounted Space: 123kByte/), "Show how much used space is accounted for"
  end
end
