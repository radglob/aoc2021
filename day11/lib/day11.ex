defmodule Grid do
  defstruct map: %{}

  def parse!(filename) do
    map =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Stream.with_index()
      |> Stream.flat_map(fn {line, row} ->
        line
        |> String.graphemes()
        |> Stream.with_index()
        |> Enum.map(fn {n, col} ->
          {{col, row}, String.to_integer(n)}
        end)
      end)
      |> Enum.into(%{})

    %Grid{map: map}
  end
end

defmodule Day11 do
  @filename "input.txt"

  def reset(map) do
    Map.new(map, fn
      {pos, value} when value > 9 ->
        {pos, 0}

      other ->
        other
    end)
  end

  def flash(map, {col, row} = pos) do
    map
    |> Map.update!(pos, &(&1 + 1))
    |> increase({col + 1, row - 1})
    |> increase({col + 1, row})
    |> increase({col + 1, row + 1})
    |> increase({col - 1, row - 1})
    |> increase({col - 1, row})
    |> increase({col - 1, row + 1})
    |> increase({col, row + 1})
    |> increase({col, row - 1})
  end

  def increase(map, pos) do
    case map do
      %{^pos => 9} ->
        flash(map, pos)

      %{^pos => n} ->
        Map.put(map, pos, n + 1)

      %{} ->
        map
    end
  end

  def loop(%{map: map} = grid) do
    map =
      map
      |> Enum.reduce(map, fn {pos, _value}, map -> increase(map, pos) end)
      |> reset()

    %{grid | map: map}
  end

  def run(steps \\ 10) do
    grid = Grid.parse!(@filename)

    grid
    |> Stream.iterate(&loop/1)
    |> Stream.take(steps + 1)
    |> Stream.map(fn %{map: map} ->
      Enum.count(map, fn {_pos, value} -> value == 0 end)
    end)
    |> Enum.sum()
  end

  def run2 do
    grid = Grid.parse!(@filename)

    grid
    |> Stream.iterate(&loop/1)
    |> Stream.take_while(fn %{map: map} ->
      Enum.any?(map, fn {_pos, value} -> value != 0 end)
    end)
    |> Enum.count()
  end
end
