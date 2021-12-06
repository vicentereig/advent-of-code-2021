defmodule AdventOfCode.VentDetector do
  @moduledoc """
    Detects Vents
  """

  def count_dangerous_areas([]), do: 0

  def count_dangerous_areas(canvas) do
    canvas
    |> List.flatten()
    |> Enum.count(fn area -> area > 1 end)
  end

  @doc """
    Plots all segments in a canvas.
    Figures out the size of the board: MxN
    Draws segments
    Counts intersection points
  """
  def plot_vents(segments) do
    segments
    |> AdventOfCode.Segment.skip_diagonals()
    |> create_canvas
  end

  def plot_all_vents(segments) do
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
    Enum.reduce(segments, 0, fn segment, count ->
      if AdventOfCode.Segment.intersects?(segment, %Point{x: x, y: y}), do: count + 1, else: count
    end)
  end

  @doc """
    Plots all segments in a canvas.

    iex> segments = [AdventOfCode.Segment.create([0,0], [0,5])]
    ...> AdventOfCode.VentDetector.create_canvas(segments)
    [[1,1,1,1,1,1]]

    iex> segments = [AdventOfCode.Segment.create([0,0], [0,5]), AdventOfCode.Segment.create([0,0], [0, 2])]
    ...> segments
    ...> |> AdventOfCode.VentDetector.create_canvas
    [[2,2,2,1,1,1]]
  """
  def create_canvas(segments) do
    bbox =
      Enum.flat_map(segments, fn s -> [s.start, s.end] end)
      |> bounding_box

    Enum.map(bbox.x1..bbox.x2, fn x ->
      Enum.map(bbox.y1..bbox.y2, fn y ->
        intersection_count(segments, x, y)
      end)
    end)
  end

  def bounding_box([%Point{x: x, y: y} | points]) do
    Enum.reduce(points, %{x1: x, y1: y, x2: x, y2: y}, fn point, box ->
      %{
        x1: min(point.x, box.x1),
        y1: min(point.y, box.y1),
        x2: max(point.x, box.x2),
        y2: max(point.y, box.y2)
      }
    end)
  end
end
