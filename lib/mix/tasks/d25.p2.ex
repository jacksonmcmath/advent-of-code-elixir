defmodule Mix.Tasks.D25.P2 do
  use Mix.Task

  import AdventOfCode.Input
  import AdventOfCode.Day25

  @shortdoc "Day 25 Part 2"
  def run(args) do
    input = get!(25)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
