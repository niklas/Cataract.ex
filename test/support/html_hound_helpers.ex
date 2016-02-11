defmodule Cataract.HtmlHoundHelpers do
  use Hound.Helpers
  def find_list(list_selector, selectors) do
    element = find_element(:css, list_selector)
    actual = "<ul id=\"root\">" <> inner_html(element) <> "</ul>"
      |> Floki.find("ul#root>li")
      |> Enum.map(fn ({_tag, _at, kids})->
        Enum.map(selectors, fn (selector)->
          case Floki.find(kids, selector) do
            [{_t, _at, [text]}] ->
              text
              |> String.replace(~r/\s+/, " ")
              |> String.strip
            _ -> nil
          end
        end)
      end)
  end
end
