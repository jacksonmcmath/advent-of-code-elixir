defmodule Mix.Tasks.D23.P1 do
  use Mix.Task

  import AdventOfCode.Input
  import AdventOfCode.Day23

  @shortdoc "Day 23 Part 1"
  def run(args) do
    input = get!(23)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
