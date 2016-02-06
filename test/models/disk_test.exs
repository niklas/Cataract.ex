defmodule Cataract.DiskTest do
  use Cataract.ModelCase

  alias Cataract.Disk

  @valid_attrs %{name: "some content", path: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Disk.changeset(%Disk{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Disk.changeset(%Disk{}, @invalid_attrs)
    refute changeset.valid?
  end
end
