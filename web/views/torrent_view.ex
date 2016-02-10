defmodule Cataract.TorrentView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :filename,
    :size_bytes,
  ]

  has_one :directory,
    serializer: Cataract.DirectoryView

end

