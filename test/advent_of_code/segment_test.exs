defmodule SegmentTest do
  use ExUnit.Case
  doctest AdventOfCode.Segment

  test "point on the segment intersects" do
    a = AdventOfCode.Segment.create([0, 9], [5, 9])
    assert true == AdventOfCode.Segment.intersects?(a, %Point{x: 1, y: 9})
  end

  test "NE point does not intersect" do
    a = AdventOfCode.Segment.create([0, 9], [5, 9])
    assert false == AdventOfCode.Segment.intersects?(a, %Point{x: 1000, y: 1000})
  end

  test "starting point intersects vertical" do
    a = AdventOfCode.Segment.create([0, 0], [0, 5])
    assert true == AdventOfCode.Segment.intersects?(a, %Point{x: 0, y: 0})
  end

  test "starting point intersects horizontal" do
    a = AdventOfCode.Segment.create([0.0, 0.0], [3.0, 0.0])
    assert true == AdventOfCode.Segment.intersects?(a, %Point{x: 0.0, y: 0.0})
  end
end
