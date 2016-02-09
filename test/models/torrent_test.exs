defmodule Cataract.TorrentTest do
  use Cataract.ModelCase

  alias Cataract.Torrent

  @valid_attrs %{filename: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Torrent.changeset(%Torrent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Torrent.changeset(%Torrent{}, @invalid_attrs)
    refute changeset.valid?
  end
end
