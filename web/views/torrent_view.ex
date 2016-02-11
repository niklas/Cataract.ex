defmodule Cataract.TorrentView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :filename,
    :size_bytes,
    :info_hash,
  ]

  has_one :directory,
    serializer: Cataract.DirectoryView

  has_one :payload_directory,
    serializer: Cataract.DirectoryView
end

