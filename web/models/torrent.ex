defmodule Cataract.Torrent do
  use Cataract.Web, :model

  schema "torrents" do
    field :name, :string
    field :filename, :string
    belongs_to :directory, Cataract.Directory

    timestamps
  end

  @required_fields ~w(filename)
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
