defmodule AdventOfCode.RiskOMaticTest do
  use ExUnit.Case
  alias AdventOfCode.RiskOMatic

  test "part 01 example" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    assert 15 == input |> RiskOMatic.solve_part1()
  end

  test "find low points" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    assert [1, 0, 5, 5] ==
             input
             |> RiskOMatic.create_heightmap()
             |> RiskOMatic.find_low_points()
  end

  test "part 01" do
    assert 468 == File.read!("data/day09/input.txt") |> RiskOMatic.solve_part1()
  end
end
