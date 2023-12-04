defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(0, fn
      {_, winners}, acc when winners < 2 -> acc + winners
      {_, winners}, acc -> acc + 2 ** (winners - 1)
    end)
  end

  def part2(input) do
    card_map = input |> parse_input() |> Map.new(fn {id, _} -> {id, 1} end)
    max_id = Enum.max_by(parse_input(input), fn {id, _} -> id end)

    input
    |> parse_input()
    |> Enum.reduce(card_map, &update(&1, max_id, &2))
    |> Map.values()
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
  end

  defp parse_card(line) do
    with ["Card", id | numbers] <- String.split(line, " ", trim: true),
         {winning, ["|" | have]} <- Enum.split_while(numbers, fn c -> c != "|" end),
         {id, _} <- Integer.parse(id) do
      {id,
       MapSet.new(winning)
       |> MapSet.intersection(MapSet.new(have))
       |> MapSet.size()}
    end
  end

  defp update({_, 0}, _, card_map), do: card_map

  defp update({id, count}, max_id, card_map) do
    Stream.unfold(id + 1, fn n -> {n, n + 1} end)
    |> Enum.take(count)
    |> Enum.reject(&(&1 > max_id))
    |> Map.new(fn k -> {k, Map.fetch!(card_map, id)} end)
    |> Map.merge(card_map, fn _, v1, v2 -> v1 + v2 end)
  end
end
