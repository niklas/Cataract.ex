defmodule Cataract.DiskView do
  use Cataract.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :path,
  ]
end
