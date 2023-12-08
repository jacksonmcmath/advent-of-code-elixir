defmodule AdventOfCode.Day08 do
  def part1(input) do
    {directions, nodes} = input |> parse_input()

    Stream.cycle(directions)
    |> Stream.with_index()
    |> Enum.reduce_while("AAA", fn {dir, idx}, node ->
      case node do
        "ZZZ" -> {:halt, idx}
        _ -> {:cont, nodes[node] |> elem(dir)}
      end
    end)
  end

  def part2(input) do
    {directions, nodes} = input |> parse_input()

    starting_nodes =
      nodes
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))
      |> IO.inspect(label: "starting nodes")

    Stream.cycle(directions)
    |> Stream.with_index()
    |> Enum.reduce_while(starting_nodes, fn {dir, idx}, current_nodes ->
      cond do
        Enum.all?(current_nodes, &String.ends_with?(&1, "Z")) ->
          {:halt, idx}

        true ->
          {:cont,
           current_nodes |> Enum.map(&(nodes[&1] |> elem(dir))) |> IO.inspect(label: "next nodes")}
      end
    end)
  end

  defp parse_input(input) do
    [directions, nodes] = String.split(input, "\n\n", trim: true)

    {directions |> parse_directions(), nodes |> parse_nodes()}
  end

  defp parse_directions(directions) do
    directions
    |> String.replace("L", "0")
    |> String.replace("R", "1")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_nodes(nodes) do
    nodes
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [node, l, r] =
        line
        |> String.replace(~r/[=(),]/, "")
        |> String.split(" ", trim: true)

      {node, {l, r}}
    end)
    |> Map.new()
  end
end
