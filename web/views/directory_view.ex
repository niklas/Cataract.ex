defmodule Cataract.DirectoryView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :path,
  ]

  has_one :disk,
    serializer: Cataract.DiskView

end

