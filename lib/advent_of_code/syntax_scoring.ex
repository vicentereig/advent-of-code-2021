defmodule AdventOfCode.SyntaxScoring do
  @chunk_open_token ["(", "[", "{", "<"]
  @chunk_close_token [")", "]", "}", ">"]

  @mapping %{
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">"
  }

  def evaluate_line("\n", {:ok, []}), do: {:halt, {:ok}}

  def evaluate_line("\n", {:ok, [found | _tail]}),
    do: {:halt, {:error, %{found: found, expected: Map.get(@mapping, found)}}}

  def evaluate_line(found, {:ok, stack}) when found in @chunk_open_token do
    {:cont, {:ok, [found] ++ stack}}
  end

  def evaluate_line(found, {:ok, []}) when found in @chunk_close_token do
    IO.inspect(found, label: "found")
    {:halt, {:error, %{expected: Map.get(@mapping, found), found: found}}}
  end

  def evaluate_line(found, {:ok, [expected_pair | tail]}) when found in @chunk_close_token do

    case [expected_pair, found] do
      ["(", ")"] ->{:cont, {:ok, tail}}
      ["{", "}"] ->{:cont, {:ok, tail}}
      ["<", ">"] ->{:cont, {:ok, tail}}
      ["[", "]"] ->{:cont, {:ok, tail}}
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
    ">" => 25137
  }
  def calculate_contest_score(errors) do
    errors
    |> Enum.map(fn {:error, %{found: found}} -> found end)
    |> Enum.map(fn found ->  Map.get(@scores, found) end)
    |> Enum.filter(fn score -> not is_nil(score) end)
    |> Enum.sum
  end
end
