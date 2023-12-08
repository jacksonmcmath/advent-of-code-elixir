defmodule AdventOfCode.Day07 do
  @card_ranks %{
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
    "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }

  def part1(input) do
    input
    |> parse_input()
    |> calculate_winnings(@card_ranks)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn {rank, hand, bid} -> {jokered_rank(rank, hand), hand, bid} end)
    |> calculate_winnings(%{@card_ranks | "J" => 0})
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand, bid] = String.split(line, " ", trim: true)
      hand = String.graphemes(hand)
      {get_rank(hand), hand, bid |> String.to_integer()}
    end)
  end

  defp calculate_winnings(hands, mapping) do
    hands
    |> Enum.group_by(&elem(&1, 0))
    |> Enum.sort_by(fn {rank, _} -> rank end)
    |> Enum.flat_map(fn {_, hands} ->
      hands |> Enum.sort(fn {_, h1, _}, {_, h2, _} -> smaller?(h1, h2, mapping) end)
    end)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, rank}, acc -> acc + bid * rank end)
  end

  defp get_rank(hand) do
    case hand
         |> Enum.group_by(& &1)
         |> Map.new(fn {a, b} -> {a, length(b)} end)
         |> Map.values()
         |> Enum.sort() do
      [1, 1, 1, 1, 1] -> 1  # high card
      [1, 1, 1, 2] -> 2     # one pair
      [1, 2, 2] -> 3        # two pair
      [1, 1, 3] -> 4        # three of a kind
      [2, 3] -> 5           # full house
      [1, 4] -> 6           # four of a kind
      [5] -> 7              # five of a kind
    end
  end

  def jokered_rank(rank, hand) do
    freq = hand |> Enum.group_by(& &1) |> Map.new(fn {a, b} -> {a, length(b)} end)

    case {rank, freq["J"]} do
      {_, nil} -> rank
      {1, _} -> 2 # high card -> one pair
      {2, _} -> 4 # one pair -> three of a kind
      {3, 1} -> 5 # two pair -> full house
      {3, 2} -> 6 # two pair -> four of a kind
      {4, _} -> 6 # three of a kind -> four of a kind
      {5, _} -> 7 # full house -> five of a kind
      {6, _} -> 7 # four of a kind -> five of a kind
      {7, _} -> rank
    end
  end

  defp smaller?([a | rest_1], [b | rest_2], mapping) do
    cond do
      mapping[a] > mapping[b] -> false
      mapping[a] < mapping[b] -> true
      true -> smaller?(rest_1, rest_2, mapping)
    end
  end
end
