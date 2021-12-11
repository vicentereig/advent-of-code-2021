defmodule DisplayV2Test do
  use ExUnit.Case
  alias AdventOfCode.Note

  test "turns patterns into numbers" do
    %Note{patterns: patterns} = Note.parse("acedgfb cdfbe | whatevs")

    assert %{
             1 => [{"a", [0]}, {"g", [0]}],
             2 => [{"b", [1, 0]}, {"c", [1, 0]}, {"d", [1, 0]}, {"e", [1, 0]}, {"f", [1, 0]}]
           } == AdventOfCode.DisplayV2.patterns_to_numbers(patterns)
  end

  test "get segments" do
    %Note{patterns: patterns} = Note.parse("acedgfb cdfbe | whatevs")

    assert ["b", "c", "d", "e", "f"] ==
             patterns
             |> AdventOfCode.DisplayV2.patterns_to_numbers()
             |> AdventOfCode.DisplayV2.get_segments(2)
  end

  test "create_decoder" do
    assert %{
             "a" => "c",
             "b" => "f",
             "c" => "g",
             "d" => "a",
             "e" => "b",
             "f" => "d",
             "g" => "e"
           } ==
             Note.parse(
               "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
             )
             |> AdventOfCode.DisplayV2.create_decoder()
  end

  test "decode all notes" do
    assert 1_011_823 = AdventOfCode.DisplayV2.decode_all_notes()
  end
end
