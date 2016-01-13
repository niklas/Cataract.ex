defmodule Cataract.Transfer do
  defstruct hash: nil,
            size_bytes: nil,
            completed_bytes: nil,
            ratio: nil,
            up_rate: nil,
            down_rate: nil

  def all_fields do
    Map.keys(Cataract.Transfer.__struct__) |> List.delete(:__struct__)
  end
end
