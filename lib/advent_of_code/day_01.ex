defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> String.replace(~r"[^\d\n]", "")
    |> String.split("\n")
    |> Enum.map(&p1_extract_calibration_value/1)
    |> Enum.sum()
  end

  defp p1_extract_calibration_value(""), do: 0

  defp p1_extract_calibration_value(input) do
    first = String.first(input)
    last = String.last(input)
    String.to_integer(first <> last)
  end

  def part2(input) do
    input
    |> replace_words_with_numbers()
    |> part1()
  end

  defp replace_words_with_numbers(input) do
    input
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end
end
