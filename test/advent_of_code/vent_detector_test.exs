defmodule VentDetectorTest do
  use ExUnit.Case
  doctest AdventOfCode.VentDetector

  test "day05 part 1 sample" do
    raw_segments = """
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
    """

    dangerous_areas = raw_segments
    |> String.split("\n")
    |> Enum.filter(fn raw -> raw != "" end)
    |> Enum.map(&AdventOfCode.Segment.parse/1)
     |> AdventOfCode.VentDetector.plot_vents()
    |> IO.inspect()
    |> AdventOfCode.VentDetector.count_dangerous_areas

    assert dangerous_areas == 5
  end
end
