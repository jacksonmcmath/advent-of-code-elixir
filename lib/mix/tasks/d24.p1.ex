defmodule Mix.Tasks.D24.P1 do
  use Mix.Task

  import AdventOfCode.Input
  import AdventOfCode.Day24

  @shortdoc "Day 24 Part 1"
  def run(args) do
    input = get!(24)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
