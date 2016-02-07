defmodule Cataract.ModuleHelpers do
  alias Ecto.Changeset

  def set_name_from_path(changeset = %Changeset{}) do
    case Changeset.get_field(changeset, :name) do
      nil ->
        case Changeset.get_field(changeset, :path) do
          nil ->
            changeset
          path ->
            Changeset.put_change(changeset, :name, Path.basename(path))
        end
      _ ->
        changeset
    end
  end
end
