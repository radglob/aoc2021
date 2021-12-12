defmodule Day12 do
  @filename "input.txt"

  def cave_map!() do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn direction ->
      [a, b] = String.split(direction, "-")
      [{a, b}, {b, a}]
    end)
    |> List.flatten()
    |> Enum.group_by(fn {start, _} -> start end)
    |> Enum.map(fn {start, dests} ->
      {start, Enum.map(dests, fn {^start, dest} -> dest end)}
    end)
    |> Enum.into(%{})
  end

  defp small_cave?(cave), do: cave == String.downcase(cave)

  def paths("end", _visited, _map), do: [true]

  def paths(cave, visited, map) do
    if small_cave?(cave) and cave in visited do
      []
    else
      Enum.flat_map(map[cave], fn c -> paths(c, [cave | visited], map) end)
    end
  end

  def small_paths("end", _visited, _, _map), do: [true]
  def small_paths("start", [_ | _], _, _map), do: []

  def small_paths(cave, visited, twice?, map) do
    cond do
      small_cave?(cave) and cave in visited and twice? ->
        []

      small_cave?(cave) and cave in visited ->
        Enum.flat_map(map[cave], fn c -> small_paths(c, visited, true, map) end)

      true ->
        Enum.flat_map(map[cave], fn c -> small_paths(c, [cave | visited], twice?, map) end)
    end
  end

  def run do
    paths("start", [], cave_map!())
    |> Enum.count()
  end

  def run2 do
    small_paths("start", [], false, cave_map!())
    |> Enum.count()
  end
end
