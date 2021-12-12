defmodule Day10 do
  @filename "input.txt"

  @opening_characters ~w(( [ { <)

  def lines! do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp matches?("{", "}"), do: true
  defp matches?("(", ")"), do: true
  defp matches?("[", "]"), do: true
  defp matches?("<", ">"), do: true
  defp matches?(_, _), do: false

  def parse(line) do
    result =
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while([], fn c, acc ->
        if Enum.member?(@opening_characters, c) do
          {:cont, [c | acc]}
        else
          opening_character = List.first(acc)

          if matches?(opening_character, c) do
            {:cont, tl(acc)}
          else
            {:halt, c}
          end
        end
      end)

    if is_binary(result) do
      {:error, result}
    else
      {:ok, result}
    end
  end

  defp corrupt_score_for_character(")"), do: 3
  defp corrupt_score_for_character("]"), do: 57
  defp corrupt_score_for_character("}"), do: 1197
  defp corrupt_score_for_character(">"), do: 25137

  def run do
    lines!()
    |> Enum.map(&parse/1)
    |> Enum.filter(fn {status, _} -> status == :error end)
    |> Enum.map(fn {:error, c} -> corrupt_score_for_character(c) end)
    |> Enum.sum()
  end

  defp matching_character("["), do: "]"
  defp matching_character("("), do: ")"
  defp matching_character("{"), do: "}"
  defp matching_character("<"), do: ">"

  def match(cs), do: Enum.map(cs, &matching_character/1)

  defp incomplete_score_for_character(")"), do: 1
  defp incomplete_score_for_character("]"), do: 2
  defp incomplete_score_for_character("}"), do: 3
  defp incomplete_score_for_character(">"), do: 4

  defp calculate_score(cs) do
    Enum.reduce(cs, 0, fn c, acc ->
      acc * 5 + incomplete_score_for_character(c)
    end)
  end

  defp middle(l) do
    size = length(l)
    midpoint = div(size, 2)
    Enum.at(l, midpoint)
  end

  def run2 do
    lines!()
    |> Enum.map(&parse/1)
    |> Enum.reject(fn {status, _} -> status == :error end)
    |> Enum.map(fn {:ok, unmatched_characters} -> match(unmatched_characters) end)
    |> Enum.map(&calculate_score/1)
    |> Enum.sort()
    |> middle()
  end
end
