defmodule AdventOfCode.V2.Submarine do
  @moduledoc """
  This module models the second version of the Submarine
  """
  @moduledoc since: "1.0.0"
  defstruct aim: 0, y: 0, x: 0
end

defmodule AdventOfCode.V2.Navigation do
  @moduledoc """
  This module models the second Navigation strategy
  """
  @moduledoc since: "1.0.0"
  @doc ~S"""
  Plays a set of commands v2

  ## Examples
    iex> %AdventOfCode.V2.Submarine{x: 15, y: 60, aim: 10} = AdventOfCode.V2.Navigation.play([{:ok, {:forward, 5}},{:ok, {:down, 5}},{:ok, {:forward, 8}},{:ok, {:up, 3}},{:ok, {:down, 8}},{:ok, {:forward, 2}}])
  """
  def play(commands) do
    submarine = %AdventOfCode.V2.Submarine{}

    Enum.reduce(commands, submarine, fn command, sub ->
      case command do
        {:ok, {:forward, position}} ->
          %AdventOfCode.V2.Submarine{
            x: sub.x + position,
            y: sub.y + position * sub.aim,
            aim: sub.aim
          }

        {:ok, {:down, position}} ->
          %AdventOfCode.V2.Submarine{x: sub.x, y: sub.y, aim: sub.aim + position}

        {:ok, {:up, position}} ->
          %AdventOfCode.V2.Submarine{x: sub.x, y: sub.y, aim: sub.aim - position}
      end
    end)
  end
end
