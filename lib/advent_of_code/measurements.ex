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
    deltas = AdventOfCode.Measurements.derive_deltas(measurements, previous_measurements)
    AdventOfCode.Measurements.count_positive_deltas(deltas)
  end

  def count_positive_deltas(deltas) do
    Enum.count(deltas, fn delta -> delta == 1 end)
  end

  def derive_deltas(enumerable1, enumerable2) do
    Enum.zip_with([enumerable1, enumerable2], fn [current, prev] -> cond do
                                                                                 prev == 0 -> 0
                                                                                 current > prev -> 1
                                                                                 current < prev -> -1
                                                                                 true -> 0
                                                                               end
    end)
  end

  @doc ~S"""
    Counts the depth increases using a sliding window of 3 measurements

    ## Examples
      Empty Sonar Report, Sliding Window of 3 Measuremetns
      iex> AdventOfCode.Measurements.count_with_sliding_window([])
      0

      Another example taken from https://adventofcode.com/2021/day/1#part2
      iex> AdventOfCode.Measurements.count_with_sliding_window([199,200,208,210,200,207,240,269,260,263])
      5

      Extended example taken from https://adventofcode.com/2021/day/1#part2
      iex> AdventOfCode.Measurements.count_with_sliding_window([199,200,208,210,200,207,240,269,260,263,200,207,240,269,260,263])
      8

      Extended example taken from https://adventofcode.com/2021/day/1#part2
      iex> AdventOfCode.Measurements.count_with_sliding_window([199,200,208,210,200,207,240,269,260,263,269,260,263,269,260,263])
      5

      Another example
      iex> AdventOfCode.Measurements.count_with_sliding_window([0,0,0,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1])
      6
  """
  def count_with_sliding_window(measurements) when length(measurements) === 0, do: 0

  def count_with_sliding_window(measurements) when length(measurements) > 0 do
    windows = windows(measurements, 3)

    interim = Enum.map(windows, fn window -> Enum.map(window, fn w -> Enum.sum(w) end) end)

    measurements_agg = Enum.zip_with(interim, fn x -> x end) |> Enum.reduce([], fn x, acc -> acc ++ x end)
    previous_measurements_agg = [0] ++ Enum.slice(measurements_agg, 0, Enum.count(measurements_agg) - 1)

    deltas = derive_deltas(measurements_agg, previous_measurements_agg)
    count_positive_deltas(deltas)
  end

  def windows(enumerable, window_size) do
    count = window_size
    step = window_size + 1
    Enum.map(0..window_size, fn i -> Enum.chunk_every(Enum.slice(enumerable, i, Enum.count(enumerable)), count, step, []) end)
  end
end