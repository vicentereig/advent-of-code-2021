defmodule AdventOfCode.Note do
  @moduledoc """
    Models a Note
  """
  defstruct patterns: [], output: []

  @doc """
    iex> AdventOfCode.Note.parse("    be ebd | fdgacbe cefbgd")
    %AdventOfCode.Note{patterns: ["be", "ebd"], output: ["fdgacbe", "cefbgd"]}
  """
  def parse(line) do
    line
    |> String.trim()
    |> String.split(" | ")
    |> then(fn [patterns, output] ->
      %AdventOfCode.Note{patterns: String.split(patterns, " "), output: String.split(output, " ")}
    end)
  end
end
