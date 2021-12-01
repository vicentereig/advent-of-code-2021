defmodule AdventOfCode.Measurements do
  @doc ~S"""
  Counts the number of times a depth measurement increases from the previous measurement.
  There is no measurement before the first measurement.

  ## Examples

    iex> AdventOfCode.Measurements.count([])
    0
  """
  def count(measurements) do
    Enum.count(measurements)
  end
end