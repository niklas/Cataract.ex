defmodule Cataract.DirectoryTest do
  use Cataract.ModelCase

  alias Cataract.Directory

  @valid_attrs %{path: "/foo/bar/baz"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Directory.changeset(%Directory{}, @valid_attrs)
    assert changeset.valid?, "is not valid"

    assert Ecto.Changeset.get_field(changeset, :name) == "baz",
      "does not set name from path"
  end

  test "changeset with invalid attributes" do
    changeset = Directory.changeset(%Directory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
