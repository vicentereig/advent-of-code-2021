defmodule AdventOfCode.Measurements do
  @doc ~S"""
  Counts the number of times a depth measurement increases from the previous measurement.
  There is no measurement before the first measurement.

  ## Examples

    iex> AdventOfCode.Measurements.count([])
    0
  """
  def count(measurements) when length(measurements) < 2, do: 0

  def count(measurements) when length(measurements) > 1 do
    previous_measurements = [0] ++ Enum.slice(measurements, 0, Enum.count(measurements) - 1)
    deltas = Enum.zip_with([measurements, previous_measurements], fn [current, prev] -> cond do
      current > prev -> 1
      current < prev -> -1
      true -> 0
      end
    end)

    Enum.count(deltas, fn delta -> delta > 0 end)
  end
end