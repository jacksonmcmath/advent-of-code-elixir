defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn {part_num, _, _}, acc -> acc + part_num end)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn {part_num, _, gear} -> {part_num, Enum.uniq(gear)} end)
    |> Enum.flat_map(fn {num, gears} -> Enum.map(gears, &{&1, num}) end)
    |> Enum.group_by(fn {a, _} -> a end, fn {_, b} -> b end)
    |> Enum.reduce(0, fn
      {_, [a, b]}, acc -> a * b + acc
      _, acc -> acc
    end)
  end

  defp parse_input(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> grid_map()

    0..(grid |> Map.keys() |> Enum.max() |> elem(0))
    |> Enum.flat_map(&collect_all(grid, &1))
    |> Enum.filter(fn {_, n, _} -> n == true end)
  end

  defp grid_map(matrix) do
    for {row, r} <- Enum.with_index(matrix),
        {cell, c} <- Enum.with_index(row),
        into: %{} do
      {{r, c}, cell}
    end
  end

  defp get_surrounding({x, y}) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {-1, -1}, {1, -1}, {-1, 1}]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  defp is_part?(grid, pos) do
    pos
    |> get_surrounding()
    |> Enum.map(&grid[&1])
    |> Enum.reject(&(is_nil(&1) || MapSet.member?(MapSet.new(~w[. 1 2 3 4 5 6 7 8 9 0]), &1)))
    |> Enum.empty?()
    |> Kernel.not()
  end

  defp get_gears(grid, pos) do
    pos
    |> get_surrounding()
    |> Enum.filter(&(grid[&1] == "*"))
  end

  defp collect_all(grid, row), do: collect_all(grid, row, 0, [])

  defp collect_all(grid, row, col, numbers) do
    case collect_one(grid, {row, col}) do
      {:halt, "", _, _} ->
        numbers

      {_, "", _, _} ->
        collect_all(grid, row, col + 1, numbers)

      {:halt, number, part?, gears} ->
        [{String.to_integer(number), part?, gears} | numbers]

      {{:cont, next}, number, part?, gears} ->
        collect_all(grid, row, next, [{String.to_integer(number), part?, gears} | numbers])
    end
  end

  defp collect_one(grid, pos), do: collect_one(grid[pos], grid, pos, "", false, [])

  defp collect_one(cur, grid, {x, y}, digits, part?, gears) when cur in ~w[1 2 3 4 5 6 7 8 9 0] do
    collect_one(
      grid[{x, y + 1}],
      grid,
      {x, y + 1},
      digits <> cur,
      part? || is_part?(grid, {x, y}),
      get_gears(grid, {x, y}) ++ gears
    )
  end

  defp collect_one(nil, _, {_, _}, digits, part?, gears), do: {:halt, digits, part?, gears}
  defp collect_one(_, _, {_, y}, digits, part?, gears), do: {{:cont, y}, digits, part?, gears}
end
