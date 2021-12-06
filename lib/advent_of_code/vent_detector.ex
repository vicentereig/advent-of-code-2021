defmodule AdventOfCode.VentDetector do
  @moduledoc """
    Detects Vents
  """

  def count_danger_areas(_), do: 0

  @doc """
    Plots all segments in a canvas.
    Figures out the size of the board: MxN
    Draws segments
    Counts intersection points
  """
  def plot_vents(segments) do
    segments
    |> create_canvas
  end

  @doc """
    Plots all segments in a canvas.
    Figures out the size of the board: MxN
    Draws segments

    iex> segments = [AdventOfCode.Segment.create([0,0], [0,5]), AdventOfCode.Segment.create([0,0], [3,0])]
    ...> AdventOfCode.VentDetector.intersection_count(segments, 0, 0)
    2
  """
  def intersection_count(segments, x, y) do
    Enum.filter(segments, fn segment ->
      AdventOfCode.Segment.intersects?(segment, %Point{x: x, y: y})
    end)
    |> Enum.count()
  end

  @doc """
    Plots all segments in a canvas.

    iex> segments = [AdventOfCode.Segment.create([0,0], [0,5])]
    ...> AdventOfCode.VentDetector.create_canvas(segments)
    [[1,1,1,1,1],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]

    iex> segments = [AdventOfCode.Segment.create([0,0], [0,5]), AdventOfCode.Segment.create([0,0], [0, 2])]
    ...> segments
    ...> |> AdventOfCode.VentDetector.create_canvas
    [[2,2,2,1,1],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
  """

  def create_canvas(segments) do
    [south_east | _] =
      Enum.flat_map(segments, fn s -> [s.start, s.end] end)
      |> Enum.uniq()
      |> Enum.sort(fn a, b -> a.y >= b.y and a.x >= b.x end)

    Enum.map(0..(south_east.y - 1), fn x ->
      Enum.map(0..(south_east.x + south_east.y - 1), fn y ->
        intersection_count(segments, x, y)
      end)
    end)
  end
end
