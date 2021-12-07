defmodule Day7 do
  @filename "input.txt"

  def inputs! do
    @filename
    |> File.read!()
    |> String.split(~r/[,\n]/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn n, acc ->
      Map.update(acc, n, 1, &(&1 + 1))
    end)
  end

  @spec difference(integer(), map()) :: integer()
  defp difference(position, positions) do
    Enum.reduce(positions, 0, fn {pos, count}, acc ->
      acc + abs(position - pos) * count
    end)
  end

  @spec growing_difference(integer(), map()) :: integer()
  defp growing_difference(position, positions) do
    Enum.reduce(positions, 0, fn {pos, count}, acc ->
      distance = abs(position - pos)
      fuel_cost = Enum.sum(1..distance)
      acc + fuel_cost * count
    end)
  end

  @spec possible_positions(map()) :: Range.t()
  defp possible_positions(positions) do
    positions
    |> Map.keys()
    |> Enum.min_max()
    |> fn {min, max} -> min..max end.()
  end

  def run do
    positions = inputs!()
    Enum.reduce(possible_positions(positions), %{}, fn position, acc ->
      Map.put(acc, position, difference(position, positions))
    end)
    |> Enum.min_by(fn {_k, v} -> v end)
  end

  def run2 do
    positions = inputs!()
    Enum.reduce(possible_positions(positions), %{}, fn position, acc ->
      Map.put(acc, position, growing_difference(position, positions))
    end)
    |> Enum.min_by(fn {_k, v} -> v end)
  end
end
