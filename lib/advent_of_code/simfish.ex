defmodule AdventOfCode.Simfish do
  @moduledoc """
  Simfish slow and not so slow.
  """
  def evolve_over(initial_population, duration_in_days) do
    Enum.reduce(1..duration_in_days, initial_population, fn _day, population ->
      Enum.flat_map(population, fn fish ->
        cond do
          fish > 0 -> [fish - 1]
          fish == 0 -> [6, 8]
        end
      end)
    end)
  end

  def faster_evolve_over(initial_population, duration_in_days) do
    fish_distro =
      initial_population
      |> Enum.frequencies()

    Enum.reduce(1..duration_in_days, fish_distro, fn _day, fish ->
      {zeros, rest} = Map.pop(fish, 0, 0)

      Enum.reduce(0..8, rest, fn
        8, acc -> Map.put(acc, 8, zeros)
        6, acc -> Map.put(acc, 6, zeros + Map.get(rest, 7, 0))
        remaining, acc -> Map.put(acc, remaining, Map.get(rest, remaining + 1, 0))
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def parse(raw_fish) do
    raw_fish
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
