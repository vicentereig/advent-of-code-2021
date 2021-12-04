defmodule AdventOfCode.BingoTest do
  use ExUnit.Case
  doctest AdventOfCode.Bingo

  test "finds a winning board" do
    boards = [
      [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      [
        [22, 13, 17, 11, 0],
        [8, 2, 23, 4, 24],
        [21, 9, 14, 16, 7],
        [6, 10, 3, 18, 5],
        [1, 12, 20, 15, 19]
      ]
    ]

    drawn_numbers = [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7]
    assert 4512 == AdventOfCode.Bingo.find_winning_board(drawn_numbers, boards)
  end

  test "finds a winning state" do
    states = [
      %{
        board: [
          [14, 21, 17, 24, 4],
          [10, 16, 15, 9, 19],
          [18, 8, 23, 26, 20],
          [22, 11, 13, 6, 5],
          [2, 0, 12, 3, 7]
        ],
        marked_numbers: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7],
        numbers_drawn: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7]
      },
      %{
        board: [
          [22, 13, 17, 11, 0],
          [8, 2, 23, 4, 24],
          [21, 9, 14, 16, 7],
          [6, 10, 3, 18, 5],
          [1, 12, 20, 15, 19]
        ],
        marked_numbers: [11, 4, 9, 7, 5],
        numbers_drawn: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7]
      }
    ]

    assert {:ok, Enum.at(states, 0)} == AdventOfCode.Bingo.find_winning_state(states)
  end

  test "board is a winner, matching row" do
    state = %{
      board: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      marked_numbers: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7],
      numbers_drawn: [0, 14, 24]
    }

    assert AdventOfCode.Bingo.is_winning?(state)
  end

  test "finds marked numbers" do
    assert [0, 2, 3, 12, 16] ==
             AdventOfCode.Bingo.find_marked_numbers(
               [
                 [14, 21, 17, 24, 4],
                 [10, 16, 15, 9, 19],
                 [18, 8, 23, 26, 20],
                 [22, 11, 13, 6, 5],
                 [2, 0, 12, 3, 7]
               ],
               [2, 0, 12, 3, 16, 100]
             )
  end

  test "calculates winning score" do
    states = [%{
      board: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      marked_numbers: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7],
      numbers_drawn: [14, 21, 17, 24, 4, 23, 11, 5, 2, 0, 7]
    }]

    4_512 == AdventOfCode.Bingo.calculate_score(states)
  end
end
