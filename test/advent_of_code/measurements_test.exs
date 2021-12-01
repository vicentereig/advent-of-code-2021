defmodule MeasurementsTest do
  use ExUnit.Case
  doctest AdventOfCode.Measurements

  test "empty sea floor depth report" do
    assert AdventOfCode.Measurements.count([]) == 0
  end

  test "flat sea floor report" do
    assert AdventOfCode.Measurements.count([1000,1000,1000,1000,1000]) == 1
  end

  test "rocky see floor report" do
    assert AdventOfCode.Measurements.count([1000,2000,1000,2000,1000]) == 3
  end

  test 'day01 run' do
    measurements = File.read!("data/day01/input.txt")
                   |> String.split("\n", trim: true)
                   |> Enum.map(&Integer.parse/1)
    assert AdventOfCode.Measurements.count(measurements) == 1549
  end
end