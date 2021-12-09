defmodule HeightMap do
  defstruct rows: []

  @infinity 10000

  def parse!(filename) do
    rows =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    %HeightMap{rows: rows}
  end

  def at(%HeightMap{rows: rows}, x, y) do
    rows
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def up(_heightmap, _x, 0), do: @infinity
  def up(heightmap, x, y), do: at(heightmap, x, y - 1)

  def down(%HeightMap{rows: rows}, _x, y) when length(rows) - 1 == y, do: @infinity
  def down(heightmap, x, y), do: at(heightmap, x, y + 1)

  def right(%HeightMap{rows: rows}, x, _y) when length(hd(rows)) - 1 == x, do: @infinity
  def right(heightmap, x, y), do: at(heightmap, x + 1, y)

  def left(_heightmap, 0, _y), do: @infinity
  def left(heightmap, x, y), do: at(heightmap, x - 1, y)

  def is_minima?(heightmap, x, y) do
    height = at(heightmap, x, y)

    height < left(heightmap, x, y) && height < right(heightmap, x, y) &&
      height < up(heightmap, x, y) && height < down(heightmap, x, y)
  end

  def minima(%HeightMap{rows: rows} = heightmap) do
    row_count = Enum.count(rows)

    row_length =
      rows
      |> List.first()
      |> Enum.count()

    for y <- 0..(row_count - 1) do
      for x <- 0..(row_length - 1) do
        if is_minima?(heightmap, x, y) do
          {x, y, at(heightmap, x, y)}
        end
      end
    end
    |> List.flatten()
    |> Enum.filter(& &1)
  end

  def traverse(visited, %HeightMap{rows: rows}, x, y)
      when x < 0 or x > length(hd(rows)) - 1 or y < 0 or y > length(rows) - 1,
      do: visited

  def traverse(visited, heightmap, x, y) do
    if Enum.member?(visited, {x, y}) || at(heightmap, x, y) >= 9 do
      visited
    else
      [{x, y} | visited]
      # Go left.
      |> traverse(heightmap, x - 1, y)
      # Go right.
      |> traverse(heightmap, x + 1, y)
      # Go up.
      |> traverse(heightmap, x, y - 1)
      # Go down.
      |> traverse(heightmap, x, y + 1)
    end
  end

  def basins(heightmap) do
    heightmap
    |> minima()
    |> Enum.map(fn {x, y, _height} -> {x, y, traverse([], heightmap, x, y)} end)
  end
end

defmodule Day9 do
  @filename "input.txt"

  def run do
    @filename
    |> HeightMap.parse!()
    |> HeightMap.minima()
    |> Enum.map(fn {_x, _y, height} -> height + 1 end)
    |> Enum.sum()
  end

  def run2 do
    @filename
    |> HeightMap.parse!()
    |> HeightMap.basins()
    |> Enum.map(fn {_, _, points} -> length(points) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end
end
