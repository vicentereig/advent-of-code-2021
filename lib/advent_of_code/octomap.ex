defmodule AdventOfCode.Octomap do
  defstruct x: 0, y: 0, energy: 0
  alias AdventOfCode.Octomap

  def create_octomap(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn raw ->
      raw
      |> String.trim()
      |> String.split("", trim: true)
      |> IO.inspect()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index(fn row, y ->
      row
      |> Enum.with_index(fn energy, x ->
        %Octomap{x: x, y: y, energy: energy}
      end)
    end)
  end

  # flash all 9s, propagate to non-zeros
  # flash new 9s, propagate to non-zeros
  # increase all non-zero in 1
  def next_octomap(map), do: map
end
