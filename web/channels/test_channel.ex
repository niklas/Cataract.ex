defmodule Cataract.TestChannel do
  use Phoenix.Channel

  def join("test:lobby", _message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    {:ok, socket}
  end

  def join("test:" <> _private, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info(:ping, socket) do
    {{year, month, day}, {hour, minute, second}} = :calendar.local_time()
    push socket, "ping", %{user: "SYSTEM", body: "#{hour}:#{minute}:#{second}"}
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    :ok
  end
end
