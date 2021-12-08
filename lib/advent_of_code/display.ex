defmodule AdventOfCode.Display do
  @moduledoc """
    Models the Seven Segment Search
  """
  alias AdventOfCode.Note

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Note.parse/1)
  end
end
