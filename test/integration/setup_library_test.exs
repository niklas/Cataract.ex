defmodule Cataract.SetupLibraryTest do
  use Cataract.ConnCase

  # Import Hound helpers
  use Hound.Helpers

  # Start a Hound session
  hound_session

  test "GET /" do
    navigate_to "/"
    assert page_source =~ "Welcome to Phoenix"
  end
end
