defmodule AdventOfCode.Commands do
  @doc ~S"""
  Parses a command given a line

  ## Examples

      iex> AdventOfCode.Commands.parse "forward 5\r\n"
      {:ok, {:forward, 5}}

      iex> AdventOfCode.Commands.parse "down 15\r\n"
      {:ok, {:down, 15}}

      iex> AdventOfCode.Commands.parse "up 10\r\n"
      {:ok, {:up, 10}}
  """
  def parse(line) do
    case String.split(line) do
      ["forward", horizontal_delta] -> {:ok, {:forward, String.to_integer(horizontal_delta)}}
      ["down", depth_delta] -> {:ok, {:down, String.to_integer(depth_delta)}}
      ["up", depth_delta] -> {:ok, {:up, String.to_integer(depth_delta)}}
    end
  end
end
