defmodule Cataract.TorrentView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :filename,
  ]

  has_one :directory,
    serializer: Cataract.DirectoryView

end

