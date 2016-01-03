defmodule Cataract.TransferChannel do
  use Phoenix.Channel
  require Logger

  def join("transfers:all", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :publish_all)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("transfers:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("all", _data, socket) do
    {:reply, { :ok, all }, socket}
  end

  # ignore incoming messages
  def handle_in(_action, _data, socket) do
    {:noreply, socket}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
  def handle_info(:publish_all, socket) do
    push socket, "add", all
    {:noreply, socket}
  end

  def terminate(_event, reason) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

  def all do
    case Cataract.Rtorrent.find_all([:hash, :up_rate, :down_rate]) do
      {:ok, transfers } ->
        %{ transfers: transfers }
      {:error, reason} ->
        Logger.error "cannot fetch transfers: " <> to_string(reason)
        %{}
    end
  end
end
