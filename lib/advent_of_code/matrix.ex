defmodule AdventOfCode.Matrix do
  @moduledoc """
  Matrix utilities
  """
  @moduledoc since: "1.0.0"

  @doc ~S"""
  Transposes a vector or a matrix

  ## Examples

    iex> AdventOfCode.Matrix.transpose([[1,1]])
    [[1], [1]]

    iex> AdventOfCode.Matrix.transpose([[1,1], [2,2], [3,3]])
    [[1,2,3], [1,2,3]]

    iex> AdventOfCode.Matrix.transpose([[1,1], [2,2], [3,3]])
    [[1,2,3], [1,2,3]]
  """
  def transpose([]), do: []

  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end
