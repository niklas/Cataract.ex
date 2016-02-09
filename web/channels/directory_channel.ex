defmodule Cataract.DirectoryChannel do
  use Phoenix.Channel

  def join("directory:index", message, socket) do
    {:ok, socket}
  end
end

