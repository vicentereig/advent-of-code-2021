defmodule AdventOfCode.DisplayV2 do
  alias AdventOfCode.Display
  alias AdventOfCode.Note

  @moduledoc """
    Models the Seven Segment Search second attempt
    **Heavily** inspired on Guy Argo's solution
  """

  def patterns_to_numbers(all_patterns) do
    all_patterns
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip(0..9)
    |> Enum.reduce(%{}, fn {segments, digit}, map ->
      segments
      |> Enum.reduce(map, fn segment, map ->
        map |> Map.update(segment, [digit], &[digit | &1])
      end)
    end)
    |> Enum.group_by(fn {_segment, numbers} -> length(numbers) end)
  end

  def get_segments(map, x) do
    map[x] |> Enum.unzip() |> elem(0)
  end

  def find_by_length(patterns, length) do
    patterns
    |> Enum.find(fn s -> String.length(s) == length end)
    |> String.split("", trim: true)
  end

  def create_decoder(%Note{patterns: patterns}) do
    segments =
      patterns
      |> patterns_to_numbers

    one = patterns |> find_by_length(2) |> MapSet.new()
    four = patterns |> find_by_length(4) |> MapSet.new()
    seven = get_segments(segments, 7) |> MapSet.new()
    eight = get_segments(segments, 8) |> MapSet.new()

    %{
      (MapSet.difference(eight, one) |> Enum.at(0)) => "a",
      (get_segments(segments, 6) |> Enum.at(0)) => "b",
      (MapSet.intersection(eight, one) |> Enum.at(0)) => "c",
      (MapSet.intersection(seven, four) |> Enum.at(0)) => "d",
      (get_segments(segments, 4) |> Enum.at(0)) => "e",
      (get_segments(segments, 9) |> Enum.at(0)) => "f",
      (MapSet.difference(seven, four) |> Enum.at(0)) => "g"
    }
  end

  def decode_numbers(notes) do
    map = %{
      "abcefg" => 0,
      "cf" => 1,
      "acdeg" => 2,
      "acdfg" => 3,
      "bcdf" => 4,
      "abdfg" => 5,
      "abdefg" => 6,
      "acf" => 7,
      "abcdefg" => 8,
      "abcdfg" => 9
    }

    Enum.map(notes, fn %Note{output: output} = note ->
      decoder = create_decoder(note)

      Enum.map_join(output, fn o ->
        decoded =
          String.split(o, "", trim: true)
          # credo:disable-for-next-line
          |> Enum.map(fn bit -> Map.get(decoder, bit) end)
          |> Enum.sort()
          |> Enum.join()

        Map.get(map, decoded)
      end)
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def decode_all_notes do
    File.read!("data/day08/input.txt")
    |> Display.parse()
    |> decode_numbers
  end
end
