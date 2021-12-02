defmodule AdventOfCode.V1.Submarine do
  @moduledoc """
  This module models the first version of the Submarine
  """
  @moduledoc since: "1.0.0"
  defstruct x: 0, y: 0
end

defmodule AdventOfCode.V1.Navigation do
  @moduledoc """
  This module models the first Navigation strategy
  """
  @moduledoc since: "1.0.0"

  @doc ~S"""
  Plays a set of commands

  ## Examples

    iex> AdventOfCode.V1.Navigation.play([{:ok, {:forward, 5}}])
    %AdventOfCode.V1.Submarine{x: 5, y: 0}

    iex> AdventOfCode.V1.Navigation.play([{:ok, {:down, 10}}, {:ok, {:up, 5}}, {:ok, {:forward, 5}}])
    %AdventOfCode.V1.Submarine{x: 5, y: 5}
  """
  def play(commands) do
    forward_commands =
      Enum.filter(commands, fn {:ok, {command, _position}} -> command == :forward end)

    forward_deltas = Enum.map(forward_commands, fn {:ok, {:forward, position}} -> position end)
    x = Enum.sum(forward_deltas)

    up_commands = Enum.filter(commands, fn {:ok, {command, _position}} -> command == :up end)
    up_deltas = Enum.map(up_commands, fn {:ok, {:up, position}} -> position end)

    down_commands = Enum.filter(commands, fn {:ok, {command, _position}} -> command == :down end)
    down_deltas = Enum.map(down_commands, fn {:ok, {:down, position}} -> position end)
    y = Enum.sum(down_deltas) - Enum.sum(up_deltas)

    %AdventOfCode.V1.Submarine{x: x, y: y}
  end
end
