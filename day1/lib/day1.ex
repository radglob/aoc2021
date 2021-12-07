defmodule Day1 do
  @filename "input.txt"

  defp pos?(n), do: n > 0

  @doc """
  We return the difference of b - a because if b is greater, we want a positive number.
  """
  defp difference([a, b]), do: b - a

  defp input do
    @filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def run do
    input()
    |> Enum.chunk_every(2, 1)
    # chunk_every will leave a list with a single element at the end. We don't need this.
    |> Enum.drop(-1)
    |> Enum.map(&difference/1)
    |> Enum.count(&pos?/1)
  end

  def run2 do
    input()
    |> Enum.chunk_every(3, 1)
    |> Enum.filter(&(length(&1) == 3))
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(&(length(&1) == 2))
    |> Enum.map(&difference/1)
    |> Enum.count(&pos?/1)
  end
end
