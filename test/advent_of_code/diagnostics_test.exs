defmodule AdventOfCode.DiagnosticsTest do
  use ExUnit.Case

  test 'day03 part 1' do
    report =
      File.read!("data/day03/input.txt")
      |> String.trim()
      |> String.split("\n")

    assert 3_309_596 == AdventOfCode.Diagnostics.calculate_power_consumption(report)
  end

  test 'calculates the power consumption' do
    report = [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010"
    ]

    assert 198 == AdventOfCode.Diagnostics.calculate_power_consumption(report)
  end

  test 'calculates oxygen generator rating' do
    report = [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010"
    ]

    assert 23 == AdventOfCode.Diagnostics.calculate_oxygen_generator_rating(report)
  end

  test 'calculates co2 scrubber rating' do
    report = [
      "00100",
      "11110",
      "10110",
      "10111",
      "10101",
      "01111",
      "00111",
      "11100",
      "10000",
      "11001",
      "00010",
      "01010"
    ]

    assert 10 == AdventOfCode.Diagnostics.calculate_co2_scrubber_rating(report)
  end
end
