defmodule Cataract.Directory do
  use Cataract.Web, :model
  alias Cataract.ModuleHelpers

  schema "directories" do
    field :name, :string
    field :path, :string
    belongs_to :disk, Cataract.Disk
    belongs_to :parent, Cataract.Directory

    timestamps
  end

  @required_fields ~w(path)
  @optional_fields ~w(name)

  def for_disk(query, disk) do
    from c in query,
    join: p in assoc(c, :disk),
    where: p.id == ^disk.id
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> ModuleHelpers.set_name_from_path
    |> unique_constraint(:path)
  end
end