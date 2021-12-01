defmodule AdventOfCode.Measurements do
  @doc ~S"""
  Counts the number of times a depth measurement increases from the previous measurement.
  There is no measurement before the first measurement.

  ## Examples
    Empty Sonar Report
    iex> AdventOfCode.Measurements.count([])
    0

    A Sonar Report with a single measurement
    iex> AdventOfCode.Measurements.count([100])
    0

    A Sonar Report over a flat sea floort.
    iex> AdventOfCode.Measurements.count([1000,1000,1000,1000,1000])
    0

    A Sonar Report over a Valley
    iex> AdventOfCode.Measurements.count([1000,1100,1200,1500,1200,1100,1000])
    3

    A Rocky Sea Floor Report (Taken from the problem statement: https://adventofcode.com/2021/day/1)
    iex> AdventOfCode.Measurements.count([199, 200, 208, 210,200,207,240,269,260, 263])
    7
  """
  def count(measurements) when length(measurements) == 0, do: 0

  def count(measurements) when length(measurements) > 0 do
    previous_measurements = [0] ++ Enum.slice(measurements, 0, Enum.count(measurements) - 1)
    deltas = Enum.zip_with([measurements, previous_measurements], fn [current, prev] -> cond do
      prev == 0 -> 0
      current > prev -> 1
      current < prev -> -1
      true -> 0
      end
    end)

    Enum.count(deltas, fn delta -> delta == 1 end)
  end
end