defmodule MeasurementsTest do
  use ExUnit.Case
  doctest AdventOfCode.Measurements

  test 'day01 run' do
    measurements = File.read!("data/day01/input.txt")
                   |> String.trim()
                   |> String.split("\n")
                   |> Enum.map(&String.to_integer/1)
    assert AdventOfCode.Measurements.count(measurements) == 1548
  end
end