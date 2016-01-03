defmodule Cataract.TestChannel do
  use Phoenix.Channel

  def join("test:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("test:" <> _private, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
