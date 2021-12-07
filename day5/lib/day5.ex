defmodule Point do
  defstruct x: 0, y: 0

  def from_tuple({x, y}), do: %Point{x: x, y: y}

  def new(x \\ 0, y \\ 0) do
    %Point{x: x, y: y}
  end
end

defmodule Line do
  defstruct p0: Point.new(), p1: Point.new()

  @input_re ~r/(\d+),(\d+) -> (\d+),(\d+)/

  def new(x0, y0, x1, y1) do
    %Line{p0: Point.new(x0, y0), p1: Point.new(x1, y1)}
  end

  defp parse_line_input(input) do
    @input_re
    |> Regex.scan(input)
    |> List.first()
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer/1)
  end

  @spec parse_line(String.t()) :: [integer()] | nil
  def parse_line(input) do
    [x0, y0, x1, y1] = parse_line_input(input)

    if x0 == x1 or y0 == y1 do
      Line.new(x0, y0, x1, y1)
    end
  end

  def slope(x0, _, x1, _) when x0 == x1, do: :infinity

  def slope(x0, y0, x1, y1) do
    abs((y1 - y0) / (x1 - x0))
  end

  def parse_diagonals(input) do
    [x0, y0, x1, y1] = parse_line_input(input)

    if x0 == x1 || y0 == y1 || slope(x0, y0, x1, y1) == 1.0 do
      Line.new(x0, y0, x1, y1)
    end
  end

  def points(%Line{p0: p0, p1: p1}) do
    cond do
      p0.x == p1.x ->
        for y <- p0.y..p1.y, do: Point.new(p0.x, y)

      p0.y == p1.y ->
        for x <- p0.x..p1.x, do: Point.new(x, p0.y)

      true ->
        p0.x..p1.x
        |> Enum.zip(p0.y..p1.y)
        |> Enum.map(&Point.from_tuple/1)
    end
    |> MapSet.new()
  end

  def intersections(%Line{} = l0, %Line{} = l1) do
    pts0 = points(l0)
    pts1 = points(l1)

    MapSet.intersection(pts0, pts1)
  end

  def intersections([l0, l1]), do: intersections(l0, l1)
end

defmodule Day5 do
  @filename "input.txt"

  def lines_from_input! do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&Line.parse_line/1)
    |> Enum.filter(& &1)
  end

  def diagonal_lines_from_input! do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&Line.parse_diagonals/1)
    |> Enum.filter(& &1)
  end

  def combinations(0, _), do: [[]]
  def combinations(_, []), do: []

  def combinations(count, [h | t]) do
    for(l <- combinations(count - 1, t), do: [h | l]) ++ combinations(count, t)
  end

  def overlapping_points do
    lines = lines_from_input!()
    pairs = combinations(2, lines)

    pairs
    |> Enum.map(&Line.intersections/1)
    |> Enum.reduce(&MapSet.union/2)
    |> Enum.count()
  end

  def overlapping_points_with_diagonals do
    lines = diagonal_lines_from_input!()
    pairs = combinations(2, lines)

    pairs
    |> Enum.map(&Line.intersections/1)
    |> Enum.reduce(&MapSet.union/2)
    |> Enum.count()
  end
end
