defmodule SubmarineCommandsTest do
  use ExUnit.Case
  doctest AdventOfCode.SubmarineCommands

  test 'day02 plays all commands' do
    commands = File.read!("data/day02/input.txt")
                   |> String.trim()
                   |> String.split("\n")
                   |> Enum.map(&AdventOfCode.SubmarineCommands.parse/1)

    %AdventOfCode.Submarine{x: x, y: y} = AdventOfCode.SubmarineCommands.play(commands)
    assert x * y == 2150351
  end

  test 'day02 part 1 problem statement' do
    commands = [
      {:ok, {:forward, 5}},
      {:ok, {:down, 5}},
      {:ok, {:forward, 8}},
      {:ok, {:up, 3}},
      {:ok, {:down, 8}},
      {:ok, {:forward, 2}},
    ]
    %AdventOfCode.Submarine{x: x, y: y} = AdventOfCode.SubmarineCommands.play(commands)
    assert x * y == 150
  end

  test 'day02 part 2 - improved nav' do
    commands = [
      {:ok, {:forward, 5}},
      {:ok, {:down, 5}},
      {:ok, {:forward, 8}},
      {:ok, {:up, 3}},
      {:ok, {:down, 8}},
      {:ok, {:forward, 2}}
    ]
    submarine = AdventOfCode.SubmarineCommands.play_v2(commands)
    assert submarine.x == 15
    assert submarine.y == 60
  end

  test 'day02 part 2 - solution' do
    commands = File.read!("data/day02/input.txt")
               |> String.trim()
               |> String.split("\n")
               |> Enum.map(&AdventOfCode.SubmarineCommands.parse/1)

    %AdventOfCode.V2.Submarine{x: x, y: y, aim: aim} = AdventOfCode.SubmarineCommands.play_v2(commands)
    assert x * y === 1842742223
  end
end