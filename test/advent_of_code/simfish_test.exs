defmodule SimfishTest do
  use ExUnit.Case
  doctest AdventOfCode.Simfish
  alias AdventOfCode.Simfish
  use Bitwise

  test "18 days of a single fish" do
    initial_population = [3]
    assert 5 == Simfish.evolve_over(initial_population, 18) |> length
  end

  test "finds 26 fish after 18 days" do
    initial_population = [3, 4, 3, 1, 2]
    assert 26 == Simfish.evolve_over(initial_population, 18) |> length
  end

  test "finds 5934 fish after 80 days" do
    initial_population = [3, 4, 3, 1, 2]
    assert 5934 == Simfish.evolve_over(initial_population, 80) |> length
  end

  test "finds yyy fish after 256 days" do
    assert 26_984_457_539 ==
             [3, 4, 3, 1, 2]
             |> Simfish.faster_evolve_over(256)
  end

  test "finds xxx fish after 256 days" do
    assert 1_710_623_015_163 ==
             File.read!("data/day06/input.txt")
             |> Simfish.parse()
             |> Simfish.faster_evolve_over(256)
  end

  test "day06 part 1 - finds 380_758 fish after 18 days" do
    assert 380_758 ==
             File.read!("data/day06/input.txt")
             |> Simfish.parse()
             |> Simfish.faster_evolve_over(80)
  end
end
