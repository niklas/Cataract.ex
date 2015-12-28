defmodule Cataract.Rtorrent do
  def bla do
    url = "ipc:///home/niklas/rails/cataract/tmp/sockets/rtorrent_test"

    :procket.socket(:unspec,:stream,0)
  end
end
