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
             |> Enum.map(fn %{height: height} -> height end)
  end

  test "part 01" do
    assert 468 == File.read!("data/day09/input.txt") |> RiskOMatic.solve_part1()
  end

  test "finds one basin size 3" do
    input = """
    219
    399
    """

    heightmap = input |> RiskOMatic.create_heightmap()
    low_points = heightmap |> RiskOMatic.find_low_points()

    assert [
             3
           ] ==
             RiskOMatic.find_basins(heightmap, low_points)
             |> Enum.map(&length/1)
  end

  test "finds basins in the example" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    heightmap = input |> RiskOMatic.create_heightmap()
    low_points = heightmap |> RiskOMatic.find_low_points()

    assert [
             3,
             9,
             14,
             9
           ] ==
             RiskOMatic.find_basins(heightmap, low_points)
             |> Enum.map(&length/1)
  end

  test "finds sample part02 result" do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    heightmap = input |> RiskOMatic.create_heightmap()
    low_points = heightmap |> RiskOMatic.find_low_points()

    assert 1134 ==
             RiskOMatic.find_basins(heightmap, low_points)
             |> RiskOMatic.solve_part2()
  end

  test "solve part02" do
    heightmap = File.read!("data/day09/input.txt") |> RiskOMatic.create_heightmap()
    low_points = heightmap |> RiskOMatic.find_low_points()

    assert 1_280_496 ==
             RiskOMatic.find_basins(heightmap, low_points)
             |> RiskOMatic.solve_part2()
  end
end
