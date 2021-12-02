defmodule V1.NavigationTest do
  use ExUnit.Case
  doctest AdventOfCode.V1.Navigation

  test 'day02 plays all commands' do
    commands =
      File.read!("data/day02/input.txt")
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&AdventOfCode.Commands.parse/1)

    %AdventOfCode.V1.Submarine{x: x, y: y} = AdventOfCode.V1.Navigation.play(commands)
    assert x * y == 2_150_351
  end

  test 'day02 part 1 problem statement' do
    commands = [
      {:ok, {:forward, 5}},
      {:ok, {:down, 5}},
      {:ok, {:forward, 8}},
      {:ok, {:up, 3}},
      {:ok, {:down, 8}},
      {:ok, {:forward, 2}}
    ]

    %AdventOfCode.V1.Submarine{x: x, y: y} = AdventOfCode.V1.Navigation.play(commands)
    assert x * y == 150
  end
end
