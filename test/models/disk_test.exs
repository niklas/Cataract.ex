defmodule Cataract.DiskTest do
  use Cataract.ModelCase

  alias Cataract.Disk

  @valid_attrs %{path: "/foo/bar/baz"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Disk.changeset(%Disk{}, @valid_attrs)
    assert changeset.valid?

    assert Ecto.Changeset.get_field(changeset, :name) == "baz",
      "does not set name from path"
  end

  test "changeset with invalid attributes" do
    changeset = Disk.changeset(%Disk{}, @invalid_attrs)
    refute changeset.valid?
  end
end
