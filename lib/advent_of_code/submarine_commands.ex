defmodule AdventOfCode.SubmarineCommands do
  @doc ~S"""
  Parses a command given a line

  ## Examples

      iex> AdventOfCode.SubmarineCommands.parse "forward 5\r\n"
      {:ok, {:forward, 5}}

      iex> AdventOfCode.SubmarineCommands.parse "down 15\r\n"
      {:ok, {:down, 15}}

      iex> AdventOfCode.SubmarineCommands.parse "up 10\r\n"
      {:ok, {:up, 10}}
  """
  def parse(line) do
    case String.split(line) do
      ["forward", horizontal_delta] -> {:ok, {:forward, String.to_integer(horizontal_delta)}}
      ["down", depth_delta] -> {:ok, {:down, String.to_integer(depth_delta)}}
      ["up", depth_delta] -> {:ok, {:up, String.to_integer(depth_delta)}}
    end
  end

  @doc ~S"""
  Plays a set of commands

  ## Examples

      iex> AdventOfCode.SubmarineCommands.play([{:ok, {:forward, 5}}])
      %AdventOfCode.Submarine{x: 5, y: 0}

        iex> AdventOfCode.SubmarineCommands.play([{:ok, {:down, 10}}, {:ok, {:up, 5}}, {:ok, {:forward, 5}}])
        %AdventOfCode.Submarine{x: 5, y: 5}
  """
  def play(commands) do
    forward_commands = Enum.filter(commands, fn {:ok, {command, _position}} -> command == :forward end)
    forward_deltas = Enum.map(forward_commands, fn {:ok, {:forward, position}} -> position  end)
    x = Enum.sum(forward_deltas)

    up_commands = Enum.filter(commands, fn {:ok, {command, _position}} -> command == :up end)
    up_deltas = Enum.map(up_commands, fn {:ok, {:up, position}} -> position end)

    down_commands = Enum.filter(commands, fn {:ok, {command, _position}} -> command == :down end)
    down_deltas = Enum.map(down_commands, fn {:ok, {:down, position}} -> position end)
    y = Enum.sum(down_deltas) - Enum.sum(up_deltas)

    %AdventOfCode.Submarine{x: x, y: y}
  end
end