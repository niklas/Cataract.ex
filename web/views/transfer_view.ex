defmodule Cataract.TransferView do
  use Cataract.Web, :view

  def render("index.json", %{transfers: transfers}) do
    transfers
  end
end
