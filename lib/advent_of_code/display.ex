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
    Enum.reduce(patterns, %{}, fn pattern, known_patterns ->
      Enum.find(@mappings, fn {number, mapping} ->
        Enum.member?([1, 7, 4], number) and String.length(pattern) == String.length(mapping)
      end)
      |> then(fn mapping ->
        cond do
          is_nil(mapping) ->
            known_patterns

          true ->
            {_, known_pattern} = mapping
            Map.put(known_patterns, pattern, known_pattern)
        end
      end)
    end)
  end

  def decode(_note) do
    # build a decoder out of patterns:
    #
    #      dddd
    #     e    a
    #     e    a
    #      ffff
    #     g    b
    #     g    b
    #      cccc
    # table of equivalences:
    # dab -> acf -> 7
    #  d -> a
    #  a -> c
    #  b -> f
    #  c -> x
    #  e -> x
    #  g -> x
    # iterate over all patterns -> build decoder as above
    #    starting with the easy patterns
    #    when matching partial encodings:  acdeg -> c,x,a,x,x
    # take decoded an apply it to all ouputs

    # to_integer and join
    0
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
