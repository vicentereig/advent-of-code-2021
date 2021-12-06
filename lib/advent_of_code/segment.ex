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

  def skip_diagonals(segments) do
    Enum.filter(segments, fn segment -> slope(segment) == 0.0 or slope(segment) == nil end)
  end

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
  def intersects?(%Segment{start: a, end: b}, c) do
    cross_product = (c.y - a.y) * (b.x - a.x) - (c.x - a.x) * (b.y - a.y)
    dot_product = (c.x - a.x) * (b.x - a.x) + (c.y - a.y) * (b.y - a.y)
    squared_length_ba = (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y)

    cond do
      Kernel.abs(cross_product) > 0.0 -> false
      dot_product < 0 -> false
      dot_product > squared_length_ba -> false
      true -> true
    end
  end

  @doc """
    Parses a segment
    ### Examples
    iex> a = AdventOfCode.Segment.create([0,9], [5,9])
    ...> AdventOfCode.Segment.parse("0,9 -> 5,9")
    a
  """
  def parse(raw_segment) do
    case String.split(raw_segment, ~r/,|->/)
         |> Enum.map(&String.trim/1)
         |> Enum.map(&String.to_integer/1) do
      [x1, y1, x2, y2] -> create([x1, y1], [x2, y2])
    end
  end
end
