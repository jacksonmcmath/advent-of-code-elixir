defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn {time, dist} ->
      time
      |> calculate_distance()
      |> Enum.filter(&(&1 > dist))
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(input) do
    {time, dist} = input |> parse_input_correctly()

    time
    |> calculate_distance()
    |> Enum.filter(&(&1 > dist))
    |> Enum.count()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(~r/\s+/)
      |> tl()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
  end

  defp parse_input_correctly(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.replace(~r/\s/, "")
      |> String.split(":")
      |> Enum.at(1)
      |> String.to_integer()
    end)
    |> List.to_tuple()
  end

  defp calculate_distance(total_time) when total_time >= 0 do
    0..total_time
    |> Enum.map(&(total_time * &1 - &1 ** 2))
  end
end
