defmodule Point do
  @moduledoc """
    Defines a 2D point
  """
  defstruct x: 0, y: 0
end

defmodule Vent do
  @moduledoc """
    Defines a Vent modelled after a 2D Line
  """
  defstruct start: %Point{}, end: %Point{}
end

defmodule AdventOfCode.Bingo.VentDetector do
  @moduledoc """
    Detects Vents
  """
  
  def create_vent([x1, y1], [x2, y2]),
    do: %Vent{
      start: %Point{x: x1, y: y1},
      end: %Point{x: x2, y: y2}
    }

  @doc """
    Determines the slope of a line.

    ### Examples

    iex> a = AdventOfCode.Bingo.VentDetector.create_vent([0,9], [5,9])
    ...> AdventOfCode.Bingo.VentDetector.slope(a)
    0.0

    iex> a = AdventOfCode.Bingo.VentDetector.create_vent([2,1], [6,3])
    ...> AdventOfCode.Bingo.VentDetector.slope(a)
    0.5
  """
  def slope(%Vent{start: %Point{x: x1, y: y1}, end: %Point{x: x2, y: y2}}) do
    rise = y2 - y1
    run = x2 - x1
    rise / run
  end
end
