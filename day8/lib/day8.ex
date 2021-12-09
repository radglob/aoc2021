defmodule Day8 do
  @filename "input.txt"

  def lines! do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp get_pattern_sequence(line) do
    line
    |> String.split("|", trim: true)
    |> List.last()
    |> String.split(" ", trim: true)
  end

  def run do
    lines!()
    |> Enum.map(&get_pattern_sequence/1)
    |> Enum.flat_map(fn digits ->
      Enum.filter(digits, fn ds -> String.length(ds) in [2, 3, 4, 7] end)
    end)
    |> Enum.count()
  end

  defp pattern_set(pattern) do
    pattern
    |> String.split("", trim: true)
    |> MapSet.new()
  end

  defp split_sequences(seqs) do
    Enum.map(seqs, fn seq ->
      seq
      |> String.split(" ", trim: true)
      |> Enum.map(&pattern_set/1)
    end)
  end

  defp pattern_by_length(patterns, n) do
    patterns
    |> Enum.find(fn p -> MapSet.size(p) == n end)
  end

  defp deduce_nine(patterns, four) do
    Enum.find(patterns, fn set ->
      difference = MapSet.difference(set, four)
      intersection = MapSet.intersection(set, four)
      MapSet.size(difference) == 2 && MapSet.size(intersection) == 4
    end)
  end

  defp deduce_zero(patterns, seven, eight, nine) do
    Enum.find(patterns, fn set ->
      intersection =
        set
        |> MapSet.intersection(seven)
        |> MapSet.intersection(nine)

      MapSet.size(set) == 6 && !Enum.member?([eight, nine], set) && intersection == seven
    end)
  end

  defp deduce_six(patterns, zero, nine) do
    Enum.find(patterns, fn set ->
      MapSet.size(set) == 6 && !Enum.member?([zero, nine], set)
    end)
  end

  defp deduce_three(patterns, one) do
    Enum.find(patterns, fn set ->
      MapSet.size(set) == 5 && MapSet.intersection(set, one) == one
    end)
  end

  defp deduce_five(patterns, six, nine) do
    Enum.find(patterns, fn set ->
      intersection = MapSet.intersection(set, six)
      MapSet.size(set) == 5 && MapSet.size(intersection) == 5 && set != nine
    end)
  end

  defp deduce_two(patterns, three, five) do
    Enum.find(patterns, fn set ->
      MapSet.size(set) == 5 && !Enum.member?([three, five], set)
    end)
  end

  defp deduce_digits([patterns, digits]) do
    one = pattern_by_length(patterns, 2)
    seven = pattern_by_length(patterns, 3)
    four = pattern_by_length(patterns, 4)
    eight = pattern_by_length(patterns, 7)

    nine = deduce_nine(patterns, four)
    zero = deduce_zero(patterns, seven, eight, nine)
    six = deduce_six(patterns, zero, nine)

    five = deduce_five(patterns, six, nine)
    three = deduce_three(patterns, one)
    two = deduce_two(patterns, three, five)

    digits_map = %{
      one => "1",
      two => "2",
      three => "3",
      four => "4",
      five => "5",
      six => "6",
      seven => "7",
      eight => "8",
      nine => "9",
      zero => "0"
    }

    digits
    |> Enum.map(&Map.get(digits_map, &1))
    |> Enum.join("")
    |> String.to_integer()
  end

  def run2 do
    lines!()
    |> Enum.map(fn line ->
      line
      |> String.split("|", trim: true)
      |> split_sequences()
      |> deduce_digits()
    end)
    |> Enum.sum()
  end
end
