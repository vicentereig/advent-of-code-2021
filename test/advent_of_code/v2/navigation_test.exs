defmodule V2.NavigationTest do
  use ExUnit.Case
  doctest AdventOfCode.V2.Navigation

  test 'day02 part 2 - improved nav' do
    commands = [
      {:ok, {:forward, 5}},
      {:ok, {:down, 5}},
      {:ok, {:forward, 8}},
      {:ok, {:up, 3}},
      {:ok, {:down, 8}},
      {:ok, {:forward, 2}}
    ]
    submarine = AdventOfCode.V2.Navigation.play(commands)
    assert submarine.x == 15
    assert submarine.y == 60
  end

  test 'day02 part 2 - solution' do
    commands = File.read!("data/day02/input.txt")
               |> String.trim()
               |> String.split("\n")
               |> Enum.map(&AdventOfCode.Commands.parse/1)

    %AdventOfCode.V2.Submarine{x: x, y: y, aim: _aim} = AdventOfCode.V2.Navigation.play(commands)
    assert x * y === 1842742223
  end
end