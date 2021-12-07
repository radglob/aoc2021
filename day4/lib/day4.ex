defmodule Board do
  defstruct rows: []

  def new(raw_board) when is_binary(raw_board) do
    rows =
      raw_board
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        row
        |> String.split(~r/\s+/, trim: true)
        |> Enum.map(fn n -> {String.to_integer(n), false} end)
      end)

    %Board{rows: rows}
  end

  def new(rows) when is_list(rows) do
    %Board{rows: rows}
  end

  def mark(%Board{rows: rows}, n) do
    Enum.map(rows, fn row ->
      Enum.map(row, fn {number, state} ->
        if number == n do
          {number, true}
        else
          {number, state}
        end
      end)
    end)
    |> Board.new()
  end

  def columns(%Board{rows: rows}) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Board.new()
  end

  defp row_winner?(%Board{rows: rows}) do
    Enum.any?(rows, fn row ->
      Enum.all?(row, fn {_, state} -> state == true end)
    end)
  end

  defp column_winner?(%Board{} = board) do
    board
    |> columns()
    |> row_winner?()
  end

  def winner?(board) do
    row_winner?(board) || column_winner?(board)
  end

  defp unmarked({_, false}), do: true
  defp unmarked({_, true}), do: false

  def sum_unmarked(%Board{rows: rows}) do
    rows
    |> List.flatten()
    |> Enum.filter(&unmarked/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end
end

defmodule Day4 do
  def inputs!() do
    [raw_draw_numbers | raw_boards] =
      "input.txt"
      |> File.read!()
      |> String.split("\n\n", trim: true)

    draw_numbers =
      raw_draw_numbers
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards = Enum.map(raw_boards, &Board.new/1)
    [draw_numbers, boards]
  end

  def first_winner do
    [draw_numbers, boards] = inputs!()

    Enum.reduce_while(draw_numbers, boards, fn n, bs ->
      bs = Enum.map(bs, &Board.mark(&1, n))

      case Enum.find(bs, &Board.winner?/1) do
        %Board{} = board ->
          score = Board.sum_unmarked(board) * n
          {:halt, score}

        _ ->
          {:cont, bs}
      end
    end)
  end

  def last_winner do
    [draw_numbers, boards] = inputs!()

    Enum.reduce_while(draw_numbers, boards, fn n, bs ->
      bs = Enum.map(bs, &Board.mark(&1, n))

      if length(bs) == 1 do
        board = List.first(bs)
        score = Board.sum_unmarked(board) * n
        {:halt, score}
      else
        {:cont, Enum.reject(bs, &Board.winner?/1)}
      end
    end)
  end
end
