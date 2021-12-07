defmodule Day2 do
  def input! do
    "input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp apply_command("forward " <> amount, {position, depth}) do
    x = String.to_integer(amount)
    {position + x, depth}
  end

  defp apply_command("down " <> amount, {position, depth}) do
    x = String.to_integer(amount)
    {position, depth + x}
  end

  defp apply_command("up " <> amount, {position, depth}) do
    x = String.to_integer(amount)
    {position, depth - x}
  end

  defp apply_command_aim("forward " <> amount, {position, depth, aim}) do
    x = String.to_integer(amount)
    {position + x, depth + x * aim, aim}
  end

  defp apply_command_aim("down " <> amount, {position, depth, aim}) do
    x = String.to_integer(amount)
    {position, depth, aim + x}
  end

  defp apply_command_aim("up " <> amount, {position, depth, aim}) do
    x = String.to_integer(amount)
    {position, depth, aim - x}
  end

  def run do
    input!()
    |> Enum.reduce({0, 0}, &apply_command/2)
    |> (fn {d, p} -> d * p end).()
  end

  def run2 do
    input!()
    |> Enum.reduce({0, 0, 0}, &apply_command_aim/2)
    |> (fn {d, p, _} -> d * p end).()
  end
end
