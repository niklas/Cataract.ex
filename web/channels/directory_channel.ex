defmodule Cataract.DirectoryChannel do
  use Phoenix.Channel
  require Logger

  alias Cataract.Directory
  alias Cataract.Repo

  def join("directory:index", message, socket) do
    {:ok, socket}
  end
end

