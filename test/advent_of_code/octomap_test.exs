defmodule AdventOfCode.OctomapTest do
  use ExUnit.Case
  alias AdventOfCode.Octomap

  test "simple pulsing octopi: 2 steps" do
    input = """
        11111
        19991
        19191
        19991
        11111
    """

    assert [
             [4, 5, 6, 5, 4],
             [5, 1, 1, 1, 5],
             [6, 1, 1, 1, 6],
             [5, 1, 1, 1, 5],
             [4, 5, 6, 5, 4]
           ] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.next_octomap()
             |> Octomap.next_octomap()
  end

  test "simple pulsing octopi: 1 steps" do
    input = """
        11111
        19991
        19191
        19991
        11111
    """

    assert [
             [3, 4, 5, 4, 3],
             [4, 0, 0, 0, 4],
             [5, 0, 0, 0, 5],
             [4, 0, 0, 0, 4],
             [3, 4, 5, 4, 3]
           ] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.next_octomap()
             |> Octomap.map(fn %Octomap{energy: e} -> e end)
  end
end
