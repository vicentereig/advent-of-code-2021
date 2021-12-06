defmodule Point do
  @moduledoc """
    Defines a 2D point
  """
  defstruct x: 0, y: 0
end

defmodule AdventOfCode.Segment do
  alias AdventOfCode.Segment

  @moduledoc """
    Defines a Vent modelled after a 2D Segment
  """
  defstruct start: %Point{}, end: %Point{}

  def create([x1, y1], [x2, y2]),
    do: %Segment{
      start: %Point{x: x1, y: y1},
      end: %Point{x: x2, y: y2}
    }

  @doc """
    Determines the slope of a line out of the rise and run: rise/run
    ### Examples
    iex> a = AdventOfCode.Segment.create([0,9], [5,9])
    ...> AdventOfCode.Segment.slope(a)
    0.0

    iex> a = AdventOfCode.Segment.create([2,1], [6,3])
    ...> AdventOfCode.Segment.slope(a)
    0.5

    iex> a = AdventOfCode.Segment.create([2,1], [2,5])
    ...> AdventOfCode.Segment.slope(a)
    nil
  """
  def slope(%Segment{start: %Point{x: x, y: _}, end: %Point{x: x, y: _}}), do: nil
  def slope(%Segment{start: %Point{x: _, y: y}, end: %Point{x: _, y: y}}), do: 0.0

  def slope(%Segment{start: %Point{x: x1, y: y1}, end: %Point{x: x2, y: y2}}),
    do: (y2 - y1) / (x2 - x1)

  @doc """
    Determines whether the point intersects
  """
  def intersects?(segment, %Point{x: x, y: y}) do
    %Segment{start: %Point{x: x1, y: y1}, end: %Point{x: x2, y: y2}} = segment
    a_to_cell = %Segment{start: %Point{x: x, y: y}, end: %Point{x: x2, y: y2}}
    slopes = [Segment.slope(segment), Segment.slope(a_to_cell)]

    case slopes do
      [nil, nil] ->
        (x >= x1 and x <= x2) and (y >= y1 and y <= y2)

      [nil, _] ->
        false

      [_, nil] ->
        false

      [slope, slope] ->
        (x >= x1 and x <= x2) and (y >= y1 and y <= y2)

      [_slope, _slope_c] ->
        false
    end
  end
end
