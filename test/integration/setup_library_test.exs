defmodule Cataract.SetupLibraryTest do
  use Cataract.ConnCase

  # Import Hound helpers
  use Hound.Helpers

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

    expected = [
      [ "private_torrents" ,  nil           ,  nil                              ],
      [ "torrents"         ,  nil           ,  nil                              ],
      [ "CatPorn"          ,  "Torrents: 1" ,  "Accounted Space: 165.9 KiBytes" ],
      [ "Incoming"         ,  "Torrents: 2" ,  "Accounted Space: 143.6 KiBytes" ],
      # TODO: these should NOT be here, they are torrents and not #root>li
      [ nil, nil, nil],
      [ nil, nil, nil],
      [ nil, nil, nil],
    ]

    element = find_element(:css, ".directories")
    selectors = ["header", ".torrents_count", ".space"]
    actual = "<ul id=\"root\">" <> inner_html(element) <> "</ul>"
      |> Exquery.tree
      |> Exquery.Query.css("ul#root>li")
      |> Enum.map(fn ({_line, kids})->
        Enum.map(selectors, fn (selector)->
          case Exquery.Query.css(kids, selector) do
            [{_, [{:text, text, _}]}] ->
              text
              |> String.replace(~r/\s+/, " ")
              |> String.strip
            _ -> nil
          end
        end)
      end)

    assert expected == actual
    #assert visible_in_page?(~r/Accounted Space: 123kByte/), "Show how much used space is accounted for"
  end
end
