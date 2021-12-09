defmodule AdventOfCode.DisplayTest do
  use ExUnit.Case

  test "finding the easy digits" do
    input = """
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    """

    assert 26 ==
             input
             |> AdventOfCode.Display.parse()
             |> AdventOfCode.Display.count_easy_numbers()
  end

  test "find the easy digits - part 1" do
    assert 476 ==
             File.read!("data/day08/input.txt")
             |> AdventOfCode.Display.parse()
             |> AdventOfCode.Display.count_easy_numbers()
  end

  test "finds the easy patterns" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert %{
             # 7
             "dab" => "acf",
             # 1
             "ab" => "cf",
             # 4
             "eafb" => "bcdf",
             # 8
             "acedgfb" => "abcdefg"
           } == AdventOfCode.Display.find_known_patterns(patterns)
  end

  #  decoded <- encoded
  #   aaaa       dddd
  #  b    c c   e    a
  #  b    c c   e    a
  #   dddd       ffff
  #  e    f f   g    b
  #  e    f f   g    b
  #   gggg       cccc  
  test "builds the decoder" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert %{"d" => "a", "e" => "b", "a" => "c", "f" => "d", "g" => "e", "b" => "f", "c" => "g"} ==
             patterns
             |> AdventOfCode.Display.find_known_patterns()
             |> AdventOfCode.Display.create_decoder()
  end

  test "decode an easy number: 7" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc"
      )

    assert 7 ==
             patterns
             |> AdventOfCode.Display.find_known_patterns()
             |> AdventOfCode.Display.create_decoder()
             |> AdventOfCode.Display.decode_number("cgb")
             |> AdventOfCode.Display.to_decimal()
  end

  test "decode an easy number: 8" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "adecgf egfdc cgeadb adbfce dafg bcfeg dge dg fadec dcbegaf | dg dcegf cdgafe gbacfed"
      )

    assert "abcdefg" ==
             patterns
             |> AdventOfCode.Display.find_known_patterns()
             |> AdventOfCode.Display.create_decoder()
             |> AdventOfCode.Display.decode_number("gbacfed")
  end

  test "decode an easy number: 4" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert 4 ==
             patterns
             |> AdventOfCode.Display.find_known_patterns()
             |> AdventOfCode.Display.create_decoder()
             |> AdventOfCode.Display.decode_number("eafb")
             |> AdventOfCode.Display.to_decimal()
  end

  test "partially decode 5" do
    %AdventOfCode.Note{patterns: patterns} =
      AdventOfCode.Note.parse(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
      )

    assert "abdfg" ==
             patterns
             |> AdventOfCode.Display.find_known_patterns()
             |> AdventOfCode.Display.create_decoder()
             |> AdventOfCode.Display.decode_number("cdfeb")
  end

  @tag :skip
  test "maps an output" do
    assert 5353 ==
             "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
             |> AdventOfCode.Display.parse()

    # |> AdventOfCode.Display.decode()
  end
end
