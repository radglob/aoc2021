defmodule Day6 do
  @filename "input.txt"

  def initial_state_from_input!() do
    initial_state =
      0..8
      |> Enum.map(&{&1, 0})
      |> Enum.into(%{})
    @filename
    |> File.read!()
    |> String.split(~r/[,\n]/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(initial_state, fn n, acc -> Map.update(acc, n, 1, &(&1 + 1)) end)
  end

  def run(days \\ 10) do
    state = initial_state_from_input!()

    Enum.reduce(1..days, state, fn _, acc ->
      new_fish = Map.get(acc, 0)

      %{
        0 => Map.get(acc, 1),
        1 => Map.get(acc, 2),
        2 => Map.get(acc, 3),
        3 => Map.get(acc, 4),
        4 => Map.get(acc, 5),
        5 => Map.get(acc, 6),
        6 => Map.get(acc, 7) + new_fish,
        7 => Map.get(acc, 8),
        8 => new_fish
      }
    end)
    |> Map.values()
    |> Enum.sum()
  end
end
