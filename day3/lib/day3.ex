defmodule Day3 do
  def inputs! do
    "input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  defp rotate(readings) do
    readings
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp most_common(digits) do
    digits
    |> Enum.frequencies()
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  defp least_common(digits) do
    digits
    |> Enum.frequencies()
    |> Enum.min_by(&elem(&1, 1))
    |> elem(0)
  end

  defp gamma_rate(readings) do
    readings
    |> rotate()
    |> Enum.map(&most_common/1)
    |> List.to_integer(2)
  end

  defp epsilon_rate(readings) do
    readings
    |> rotate()
    |> Enum.map(&least_common/1)
    |> List.to_integer(2)
  end

  def power_consumption do
    readings = inputs!()
    gamma_rate(readings) * epsilon_rate(readings)
  end

  defp max_or_one(%{48 => a, 49 => b}) when a == b, do: 49
  defp max_or_one(%{48 => a, 49 => b}) when a > b, do: 48
  defp max_or_one(%{48 => a, 49 => b}) when a < b, do: 49

  defp keep_most_common_bit(_index, readings) when length(readings) == 1, do: readings

  defp keep_most_common_bit(index, readings) do
    most_common =
      readings
      |> Enum.map(&Enum.at(&1, index))
      |> Enum.frequencies()
      |> max_or_one()

    Enum.filter(readings, fn r -> Enum.at(r, index) == most_common end)
  end

  defp oxygen_generator_rating(readings) do
    line_length =
      readings
      |> List.first()
      |> length()

    0..line_length
    |> Enum.reduce(readings, &keep_most_common_bit/2)
    |> List.first()
    |> List.to_integer(2)
  end

  defp min_or_zero(%{48 => a, 49 => b}) when a == b, do: 48
  defp min_or_zero(%{48 => a, 49 => b}) when a < b, do: 48
  defp min_or_zero(%{48 => a, 49 => b}) when a > b, do: 49

  defp keep_least_common_bit(_index, readings) when length(readings) == 1, do: readings
  defp keep_least_common_bit(index, readings) do
    least_common =
      readings
      |> Enum.map(&Enum.at(&1, index))
      |> Enum.frequencies()
      |> min_or_zero()

    Enum.filter(readings, fn r -> Enum.at(r, index) == least_common end)
  end

  defp co2_scrubber_rating(readings) do
    line_length =
      readings
      |> List.first()
      |> length()

    0..line_length
    |> Enum.reduce(readings, &keep_least_common_bit/2)
    |> List.first()
    |> List.to_integer(2)
  end

  def life_support_rating do
    readings = inputs!()
    oxygen_generator_rating(readings) * co2_scrubber_rating(readings)
  end
end
