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
    |> set_name_from_path
    |> unique_constraint(:path)
  end

  def set_name_from_path(changeset = %Ecto.Changeset{}) do
    case get_field(changeset, :name) do
      nil ->
        case get_field(changeset, :path) do
          nil ->
            changeset
          path ->
            put_change(changeset, :name, Path.basename(path))
        end
      _ ->
        changeset
    end
  end
end
