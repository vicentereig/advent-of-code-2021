defmodule MeasurementsTest do
  use ExUnit.Case
  doctest AdventOfCode.Measurements

  test 'day01 count sliding window = 1' do
    measurements = File.read!("data/day01/input.txt")
                   |> String.trim()
                   |> String.split("\n")
                   |> Enum.map(&String.to_integer/1)
    assert AdventOfCode.Measurements.count(measurements) == 1548
  end

  test 'day01 count sliding window = 3' do
    measurements = File.read!("data/day01/input.txt")
                   |> String.trim()
                   |> String.split("\n")
                   |> Enum.map(&String.to_integer/1)
    assert AdventOfCode.Measurements.count_with_sliding_window(measurements) == 1589
  end
end