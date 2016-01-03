defmodule Cataract.TransferChannel do
  use Phoenix.Channel
  require Logger

  def join("transfers:all", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("transfers:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("all", _data, socket) do
    payload = %{ "transfers" => [%{ "hash" => "XXX", "up_rate" => 23, "down_rate" => 42 }] }
    {:reply, { :ok, payload }, socket}
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
  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    payload = %{ "transfers" => [
        %{ "hash" => "YYY", "up_rate" => :random.uniform(1000000), "down_rate" => :random.uniform(1000000)}
      ]}

    push socket, "add", payload
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
end
