defmodule Cataract.HtmlHoundHelpers do
  use Hound.Helpers
  def find_list(list_selector, line_selector, selectors) do
    actual = find_element(:tag, "html")
      |> inner_html
      |> Floki.parse
      |> Floki.find(list_selector <> ">" <> line_selector)
      |> Enum.map(fn ({_tag, _at, kids})->
        Enum.map(selectors, fn (selector)->
          case Floki.find(kids, selector) do
            [{_t, _at, [text]}] ->
              strip(text)
            [element] ->
              element
              |> Floki.DeepText.get
              |> strip
            _ -> nil
          end
        end)
      end)
  end

  def strip(text) do
    text
      |> String.replace(~r/\s+/, " ")
      |> String.strip
  end
end
