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

    iex> a = AdventOfCode.Bingo.Segment.create([0,5], [10,5])
    ...> b = AdventOfCode.Bingo.Segment.create([5,5], [2,9])
    ...> AdventOfCode.Bingo.Segment.intersect?(a, b)
    true

    iex> a = AdventOfCode.Bingo.Segment.create([0,0], [0,5])
    ...> b = AdventOfCode.Bingo.Segment.create([0,0], [5,0])
    ...> AdventOfCode.Bingo.Segment.intersect?(a, b)
    true

    iex> a = AdventOfCode.Bingo.Segment.create([0,0], [0,5])
    ...> b = AdventOfCode.Bingo.Segment.create([0,6], [0,12])
    ...> AdventOfCode.Bingo.Segment.intersect?(a, b)
    false

  """
  def intersect?(a, b) do
    case Enum.map([a, b], &slope/1) do
      # segments are parallel. vertical and parallel
      [slope, slope] ->
        false

      # segment a is vertical
      [nil, slope] ->
        x = a.start.x
        c2 = calculate_coef(b.start, slope)
        y = x * slope + c2

        (y > a.start.y and x < a.end.y) or (y > a.end.y and y < a.start.y)

      # segment b is vertical
      [slope, nil] ->
        x = b.start.x
        c1 = calculate_coef(a.start, slope)
        y = x * slope + c1

        (y > b.start.y and x < b.end.y) or (y > b.end.y and y < b.start.y)

      [slope_a, slope_b] ->
        c_a = calculate_coef(a.start, slope_a)
        c_b = calculate_coef(b.start, slope_b)
        x = (c_a - c_b) / (slope_a - slope_b)

        (x > a.start.x and x < a.end.x) or (x > a.end.x and x < a.start.x) or
          (x > b.start.x and x < b.end.x) or (x > b.end.x and x < b.start.x)
    end
  end

  def calculate_coef(%Point{x: x, y: y}, slope), do: y - slope * x
end
