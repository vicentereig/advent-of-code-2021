defmodule AdventOfCode.OctomapTest do
  use ExUnit.Case
  alias AdventOfCode.Octomap

  test "part 1 example" do
    input = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """

    assert 204 ==
             input
             |> Octomap.create_octomap()
             |> Octomap.count_flashes_over_steps(10)
  end

  test "simple recharge" do
    input = """
    34
    49
    """

    assert [[4, 5], [5, 10]] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.recharge()
             |> Octomap.map(&Octomap.to_energy/1)
  end

  test "simple recharge and flash" do
    input = """
    34
    49
    """

    assert [[4, 5], [5, 0]] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.recharge()
             |> Octomap.flash()
             |> Octomap.map(&Octomap.to_energy/1)
  end

  test "simple recharge, flash, and propagate" do
    input = """
    34
    49
    """

    assert [[5, 6], [6, 0]] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.recharge()
             |> Octomap.flash()
             |> Octomap.propagate_energy()
             |> Octomap.mark_flashed
             |> Octomap.map(&Octomap.to_energy/1)
  end

  test "simple recharge, flash, propagate, flash and propagate" do
    input = """
    34
    49
    """

    assert [[5, 6], [6, 0]] ==
             input
             |> Octomap.create_octomap()
             |> Octomap.recharge()
             |> Octomap.flash()
             |> Octomap.propagate_energy()
             |> Octomap.mark_flashed()
             |> Octomap.flash()
             |> Octomap.propagate_energy()
             |> Octomap.mark_flashed()
             |> Octomap.map(&Octomap.to_energy/1)
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
             |> Enum.to_list
             |> then( fn [map] ->
                map |> Octomap.map(&Octomap.to_energy/1)
             end)

  end

  test "what is the opposite of Enum.reduce? Unfold." do
    assert nil ==
             %{result: 0}
             |> Stream.unfold(fn
               %{result: 22} -> nil
               %{result: result} = state -> {result, %{state | result: result + 1}}
             end)
             |> Enum.at(22)
  end

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
             |> Enum.to_list
             |> then( fn [map] ->
               map |> Octomap.map(&Octomap.to_energy/1)
             end)

  end

  test "upper octopus did not flash" do
    assert false ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.upper_flashed?(%Octomap{x: 4, y: 4})
  end

  test "upper octopus does not exist" do
    assert false ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.upper_flashed?(%Octomap{x: 0, y: 1})
  end

  test "upper left octopus did flash" do
    assert true ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.upper_left_flashed?(%Octomap{x: 4, y: 4})
  end

  test "lower right octopus did not flash" do
    assert false ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.lower_right_flashed?(%Octomap{x: 4, y: 4})
  end

  test "lower right octopus did flash" do
    assert true ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.lower_right_flashed?(%Octomap{x: 2, y: 2})
  end

  test "right did not flash" do
    assert false ==
             [
               [3, 4, 5, 4, 3],
               [4, 0, 0, 0, 4],
               [5, 0, 0, 0, 5],
               [4, 0, 0, 0, 4],
               [3, 4, 5, 4, 3]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.upper_left_flashed?(%Octomap{x: 4, y: 5})
  end

  test "neighbours did flash" do
    assert [true, true, true, true, true, true, true, true] ==
             [
               [4, 5, 6, 5, 4],
               [5, 0, 0, 0, 5],
               [6, 0, 1, 0, 6],
               [5, 0, 0, 0, 5],
               [4, 5, 6, 5, 4]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.did_they_flash?(%Octomap{x: 2, y: 2})
  end

  test "neighbour did flash" do
    assert [false, false, false, false, false, false, false, true] ==
             [
               [3, 4],
               [4, 0]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.did_they_flash?(%Octomap{x: 0, y: 0})
  end

  test "propagate energy" do
    assert [[4, 5], [5, 0]] ==
             [
               [3, 4],
               [4, 0]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.propagate_energy()
             |> Octomap.map(&Octomap.to_energy/1)
  end

  test "propagate bis" do
    assert [
             [3, 4, 5, 4, 3],
             [4, 0, 0, 0, 4],
             [5, 0, 10, 0, 5],
             [4, 0, 0, 0, 4],
             [3, 4, 5, 4, 3]
           ] ==
             [
               [2, 2, 2, 2, 2],
               [2, 0, 0, 0, 2],
               [2, 0, 2, 0, 2],
               [2, 0, 0, 0, 2],
               [2, 2, 2, 2, 2]
             ]
             |> Octomap.to_map()
             |> Octomap.map(fn %Octomap{energy: e, flashed: f} = o ->
               if e == 0, do: %{o | flashed: !f}, else: o
             end)
             |> Octomap.propagate_energy()
             |> Octomap.map(&Octomap.to_energy/1)
  end
end
