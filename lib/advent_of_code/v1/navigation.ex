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
    Enum.reduce(commands, %AdventOfCode.V1.Submarine{}, fn command, submarine ->
      case command do
        {:ok, {:forward, position}} -> Map.put(submarine, :x, submarine.x + position)
        {:ok, {:down, position}} -> Map.put(submarine, :y, submarine.y + position)
        {:ok, {:up, position}} -> Map.put(submarine, :y, submarine.y - position)
      end
    end)
  end
end
