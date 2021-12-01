defmodule MeasurementsTest do
  use ExUnit.Case
  doctest AdventOfCode.Measurements

  test "basic case" do
    assert AdventOfCode.Measurements.count([]) == 0
  end
end