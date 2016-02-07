defmodule Cataract.Disk do
  use Cataract.Web, :model

  schema "disks" do
    field :name, :string
    field :path, :string

    timestamps
  end

  @required_fields ~w(path)
  @optional_fields ~w(name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
