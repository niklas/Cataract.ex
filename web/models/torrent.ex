defmodule Cataract.Torrent do
  use Cataract.Web, :model

  schema "torrents" do
    field :name, :string
    field :filename, :string
    field :size_bytes, :integer
    field :info_hash, :string
    belongs_to :directory, Cataract.Directory
    belongs_to :payload_directory, Cataract.Directory

    timestamps
  end

  @required_fields ~w(filename)
  @optional_fields ~w(name size_bytes info_hash payload_directory_id)

  alias Cataract.Repo

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Updates the payload directory and returns the updated record
  """
  def update_payload_directory!(torrent, dir) do
    id = case dir do
      nil -> nil
      _   -> dir.id
    end
    torrent
      |> changeset(%{payload_directory_id: id})
      |> Repo.update!
    # reload so we can preload assoc with the new value
    Repo.get(__MODULE__, torrent.id)
  end

  def absolute_file_path(torrent) do
    torrent = Repo.preload(torrent, directory: :disk)
    Path.join(
      Cataract.Directory.absolute_path(torrent.directory),
      torrent.filename
    )
  end

  def absolute_payload_path(torrent) do
    torrent = Repo.preload(torrent, payload_directory: :disk)
    if torrent.payload_directory do
      Path.join(
        Cataract.Directory.absolute_path(torrent.payload_directory),
        torrent.filename
      )
    else
      {:error, :no_payload_directory} # TODO meh!?
    end
  end
end
