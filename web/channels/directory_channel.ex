defmodule Cataract.DirectoryChannel do
  use Phoenix.Channel
  require Logger

  alias Cataract.Directory
  alias Cataract.Repo

  def join("directory:index", _message, socket) do
    Logger.debug "=== join #{socket.topic}"

    {:ok, socket}
  end
end

