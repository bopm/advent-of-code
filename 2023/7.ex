defmodule CamelCards do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.split(row, " ", trim: true) end)
  end

  def process(card) do
    String.split(card, "", trim: true)
    |> Enum.group_by(fn e -> e end)
  end

  def counts(card) do
    process(card)
    |> Map.values
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> dbg()
  end

  def power(card, jokers) do
    case counts(card, jokers) do
      [5] -> 6
      [4, 1] -> 5
      [3, 2] -> 4
      [3, 1, 1] -> 3
      [2, 2, 1] -> 2
      [2, 1, 1, 1] -> 1
      _ -> 0
    end
  end

  def position_power(position) do
    Integer.to_string(Enum.find_index(["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"], fn x -> x == position end), 16)
  end

  def card_position_power(card) do
    String.split(card, "", trim: true)
    |> Enum.map(fn char -> position_power(char) end)
    |> Enum.join
    |> Integer.parse(16)
    |> elem(0)
  end

  def power_with_jokers(card, jokers ||||||||||)

  def hand(input, jokers \\ false) do
    groups = parse(input)
    |> Enum.group_by(fn [card, _bid] -> power(card) end)

    groups
    |> Map.keys
    |> Enum.sort(:desc)
    |> Enum.map(fn power -> Map.get(groups, power) end)
    |> Enum.map(fn group -> Enum.sort_by(group, &(card_position_power(Enum.at(&1, 0))), :desc) end)
    |> List.flatten
    |> Enum.chunk_every(2)
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn {[_card, bid], rank} -> String.to_integer(bid) * (rank + 1) end)
    |> Enum.sum
    |> dbg()
  end
end
