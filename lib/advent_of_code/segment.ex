defmodule Point do
  @moduledoc """
    Defines a 2D point
  """
  defstruct x: 0, y: 0
end

defmodule AdventOfCode.Bingo.Segment do
  alias AdventOfCode.Bingo.Segment

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

    iex> a = AdventOfCode.Bingo.Segment.create([0,9], [5,9])
    ...> AdventOfCode.Bingo.Segment.slope(a)
    0.0

    iex> a = AdventOfCode.Bingo.Segment.create([2,1], [6,3])
    ...> AdventOfCode.Bingo.Segment.slope(a)
    0.5

    iex> a = AdventOfCode.Bingo.Segment.create([2,1], [2,5])
    ...> AdventOfCode.Bingo.Segment.slope(a)
    nil
  """
  def slope(%Segment{start: %Point{x: x1, y: _}, end: %Point{x: x2, y: _}}) when x2 - x1 == 0,
    do: nil

  def slope(%Segment{start: %Point{x: x1, y: y1}, end: %Point{x: x2, y: y2}}),
    do: (y2 - y1) / (x2 - x1)

  @doc """
    Determines whether two segments intersect

    ### Examples

    iex> a = AdventOfCode.Bingo.Segment.create([0,9], [5,9])
    ...> b = AdventOfCode.Bingo.Segment.create([0,9], [2,9])
    ...> AdventOfCode.Bingo.Segment.intersect?(a, b)
    true

  """
  def intersect?(a, b) do
    slopes = Enum.map([a, b], &slope/1)

    case slopes do
      # both lines are vertical an parallel
      [nil, nil] ->
        false

      # segments are parallel
      [slope, slope] ->
        false

      # segment a is vertical
      [nil, slope] ->
        x = a.start.x
        c2 = b.start.y - slope * b.start.x
        y = x * slope + c2

        if (y > a.start.y and x < a.end.y) or (y > a.end.y and y < a.start.y),
          do: true,
          else: false

      # segment b is vertical
      [slope, nil] ->
        x = b.start.x
        c1 = a.start.y - slope * a.start.x
        y = x * slope + c1

        if (y > b.start.y and x < b.end.y) or (y > b.end.y and y < b.start.y),
          do: true,
          else: false

      [slope_a, slope_b] ->
        c_a = a.start.y - slope_a * a.start.x
        c_b = b.start.y - slope_b * b.start.x
        x = (c_a - c_b) / (slope_a - slope_b)

        (x > a.start.x and x < a.end.x) or (x > a.end.x and x < a.start.x) or
          (x > b.start.x and x < b.end.x) or (x > b.end.x and x < b.start.x)
    end
  end
end
