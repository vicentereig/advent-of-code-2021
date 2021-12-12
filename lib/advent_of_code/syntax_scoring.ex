defmodule AdventOfCode.SyntaxScoring do
  @moduledoc """
    Syntax Scoring Party
  """
  @chunk_open_token ["(", "[", "{", "<"]
  @chunk_close_token [")", "]", "}", ">"]

  @mapping %{
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">"
  }

  def evaluate_line("\n", {:ok, []}),
    do: {:halt, {:ok}}

  def evaluate_line("\n", {:ok, stack}),
    do: {:cont, {:incomplete, %{autocomplete: autocomplete(stack)}}}

  # (), ], }, or >)
  # simple autocomplete
  def autocomplete(stack) do
    stack
    |> Enum.map(fn token -> Map.get(@mapping, token) end)
  end

  def evaluate_line(found, {:ok, stack}) when found in @chunk_open_token do
    if found == "\n", do: {:halt, {:ok}}, else: {:cont, {:ok, [found] ++ stack}}
  end

  def evaluate_line(found, {:ok, []}) when found in @chunk_close_token do
    {:halt, {:error, %{expected: Map.get(@mapping, found), found: found}}}
  end

  def evaluate_line(found, {:ok, [expected_pair | tail]}) when found in @chunk_close_token do
    case [expected_pair, found] do
      ["(", ")"] ->
        {:cont, {:ok, tail}}

      ["{", "}"] ->
        {:cont, {:ok, tail}}

      ["<", ">"] ->
        {:cont, {:ok, tail}}

      ["[", "]"] ->
        {:cont, {:ok, tail}}

      _ ->
        {:halt, {:error, %{expected: Map.get(@mapping, expected_pair), found: found}}}
    end
  end

  def parse_lines(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> Enum.into(["\n"], line) end)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split("")
    |> Enum.filter(fn token -> token != "" end)
    |> Enum.reduce_while({:ok, []}, &evaluate_line/2)
  end

  @scores %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25_137
  }

  def calculate_contest_score(errors) do
    errors
    |> Enum.map(fn {:error, %{found: found}} -> found end)
    |> Enum.map(fn found -> Map.get(@scores, found) end)
    |> Enum.filter(fn score -> not is_nil(score) end)
    |> Enum.sum()
  end

  def autocomplete_score(errors) do
    errors
    |> Enum.filter(fn {error_type, _} -> error_type == :incomplete end)
    |> Enum.map(fn {_, %{autocomplete: stack}} -> stack end)
    |> Enum.map(&calculate_autocomplete_score/1)
  end

  def calculate_autocomplete_score(autocomplete) do
    autocomplete
    |> Enum.reduce(0, fn autocompleted_token, total_score ->
      char_score =
        case autocompleted_token do
          ")" -> 1
          "]" -> 2
          "}" -> 3
          ">" -> 4
        end

      total_score * 5 + char_score
    end)
  end

  def pick_winner(scores) do
    scores
    |> Enum.sort()
    |> then(fn scores ->
      Enum.at(scores, 0 + div(length(scores), 2))
    end)
  end
end
