defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&extrapolate_last/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(&extrapolate_first/1)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp extrapolate_last(values) when length(values) > 1 do
    values |> differences() |> extrapolate_last() |> Kernel.+(List.last(values))
  end

  defp extrapolate_last([value]), do: value

  defp extrapolate_first(values) when length(values) > 1 do
    dif = values |> differences() |> extrapolate_first()
    List.first(values) - dif
  end

  defp extrapolate_first([value]), do: value

  defp differences(values) when is_list(values) do
    Enum.zip(values, Enum.drop(values, 1)) |> Enum.map(fn {a, b} -> b - a end)
  end
end
