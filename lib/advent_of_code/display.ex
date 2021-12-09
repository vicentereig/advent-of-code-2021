defmodule AdventOfCode.Display do
  @moduledoc """
    Models the Seven Segment Search
  """
  alias AdventOfCode.Note

  @mappings [
    {0, "abcefg"},
    {1, "cf"},
    {2, "acdeg"},
    {3, "acdfg"},
    {4, "bcdf"},
    {5, "abdfg"},
    {6, "abdfeg"},
    {7, "acf"},
    {8, "abcdefg"},
    {9, "abcdfg"}
  ]

  def find_known_patterns(patterns) do
    Enum.reduce(patterns, %{}, fn encoded, known_patterns ->
      Enum.find(@mappings, fn {number, mapping} ->
        Enum.member?([1, 4, 7, 8], number) and String.length(encoded) == String.length(mapping)
      end)
      |> then(fn mapping ->
        cond do
          is_nil(mapping) ->
            known_patterns

          true ->
            {_, known_pattern} = mapping
            Map.put(known_patterns, encoded, known_pattern)
        end
      end)
    end)
  end

  def create_decoder(known_patterns) do
    Map.keys(known_patterns)
    |> Enum.sort_by(fn x -> String.length(x) end)
    |> IO.inspect()
    |> Enum.reduce(%{}, fn encoded, acc ->
      encoded_bits = String.split(encoded, "") |> Enum.filter(fn x -> x != "" end)
      decoded = Map.get(known_patterns, encoded)
      decoded_bits = String.split(decoded, "") |> Enum.filter(fn x -> x != "" end)

      Enum.zip_reduce(encoded_bits, decoded_bits, acc, fn d, e, map ->
        if Enum.member?(Map.keys(map), d) do
          map
        else
          map = Map.put(map, d, e)
          if d == "c", do: IO.inspect(map)
          map
        end
      end)
    end)
  end

  def decode_number(decoder, encoded_number) do
    encoded_number
    |> String.split("")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x ->
      Map.get(decoder, x, "x")
    end)
    |> Enum.sort()
    |> Enum.join()
  end

  def to_decimal(decoded_segment) do
    Enum.find(@mappings, fn {number, pattern} -> pattern == decoded_segment end)
    |> then(fn {number, _} -> number end)
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Note.parse/1)
  end

  def count_easy_numbers(notes) do
    pattern_lengths =
      @mappings
      |> Enum.filter(fn {number, _} -> Enum.member?([1, 4, 7, 8], number) end)
      |> Enum.map(fn {_, pattern} -> String.length(pattern) end)

    notes
    |> Enum.flat_map(fn %Note{output: output} ->
      output
      |> Enum.map(fn o -> String.length(o) end)
    end)
    |> Enum.count(fn l -> Enum.member?(pattern_lengths, l) end)
  end
end
