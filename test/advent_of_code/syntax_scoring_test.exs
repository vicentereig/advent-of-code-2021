defmodule AdventOfCode.SyntaxScoringTest do
  use ExUnit.Case
  alias AdventOfCode.SyntaxScoring

  test "detects a valid line with ()" do
    assert {:ok} ==
             "((()))\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects an invalid line in ((" do
    assert {:error, %{expected: ")", found: "("}} ==
             "(((\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with []" do
    assert {:ok} ==
             "[]\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a invalid line with [)" do
    assert {:error, %{expected: "]", found: ")"}} ==
             "[)\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a invalid line with [}" do
    assert {:error, %{expected: "]", found: "}"}} ==
             "[}\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with {}" do
    assert {:ok} ==
             "{}\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with <>" do
    assert {:ok} ==
             "<>\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with (<>)" do
    assert {:ok} ==
             "(<>)\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with (<><>)" do
    assert {:ok} ==
             "(<><>)\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a valid line with (<>[]<>)" do
    assert {:ok} ==
             "(<>[{}<{}>]<>)\n"
             |> SyntaxScoring.parse_line()
  end

  test "detects a corrupted line" do
    assert {:error, %{found: "}", expected: "]"}} ==
             "{([(<{}[<>[]}>{[]{[(<()>"
             |> SyntaxScoring.parse_line()
  end

  test "parse lines" do
    lines = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    """

    assert [ {:error, %{expected: "}", found: "{"}},
             {:error, %{expected: ")", found: "("}}] == lines |> SyntaxScoring.parse_lines
  end

  test "solve example" do
    lines = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    assert 26397 == lines
                    |> SyntaxScoring.parse_lines
                    |> SyntaxScoring.calculate_contest_score
  end

  test "solve day10 part1" do
    assert 358737 == File.read!("data/day10/input.txt")
    |> SyntaxScoring.parse_lines
    |> SyntaxScoring.calculate_contest_score
  end
end
