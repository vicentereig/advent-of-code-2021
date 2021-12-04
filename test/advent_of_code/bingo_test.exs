defmodule AdventOfCode.BingoTest do
  use ExUnit.Case

  test "play" do
    assert 51_776 == AdventOfCode.Bingo.play()
  end

  test "part 2" do
    numbers = AdventOfCode.Bingo.get_numbers()
    boards = AdventOfCode.Bingo.get_boards()

    winning_board =
      AdventOfCode.Bingo.find_winning_boards(numbers, boards)
      |> Enum.at(-1)

    assert 16_830 == AdventOfCode.Bingo.calculate_score(winning_board)
  end

  test "find last to win board" do
    numbers = [
      7,
      4,
      9,
      5,
      11,
      17,
      23,
      2,
      0,
      14,
      21,
      24,
      10,
      16,
      13,
      6,
      15,
      25,
      12,
      22,
      18,
      20,
      8,
      19,
      3,
      26,
      1
    ]

    boards = [
      [
        [22, 13, 17, 11, 0],
        [8, 2, 23, 4, 24],
        [21, 9, 14, 16, 7],
        [6, 10, 3, 18, 5],
        [1, 12, 20, 15, 19]
      ],
      [
        [3, 15, 0, 2, 22],
        [9, 18, 13, 17, 5],
        [19, 8, 7, 25, 23],
        [20, 11, 10, 24, 4],
        [14, 21, 16, 12, 6]
      ],
      [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ]
    ]

    winning_board =
      AdventOfCode.Bingo.find_winning_boards(numbers, boards)
      |> Enum.at(-1)

    assert 1924 == AdventOfCode.Bingo.calculate_score(winning_board)
  end

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

    drawn_numbers = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24]
    assert 4512 == AdventOfCode.Bingo.find_winning_board(drawn_numbers, boards)
  end

  test "play a bingo round" do
    states = [
      %{
        board: [
          [14, 21, 17, 24, 4],
          [10, 16, 15, 9, 19],
          [18, 8, 23, 26, 20],
          [22, 11, 13, 6, 5],
          [2, 0, 12, 3, 7]
        ],
        marked_numbers: [],
        numbers_drawn: []
      },
      %{
        board: [
          [22, 13, 17, 11, 0],
          [8, 2, 23, 4, 24],
          [21, 9, 14, 16, 7],
          [6, 10, 3, 18, 5],
          [1, 12, 20, 15, 19]
        ],
        marked_numbers: [],
        numbers_drawn: []
      }
    ]

    updated_states =
      Enum.map(states, fn state ->
        state
        |> Map.put(:marked_numbers, [14])
        |> Map.put(:numbers_drawn, [14])
      end)

    assert {:cont, updated_states} == AdventOfCode.Bingo.play_round(14, states)
  end

  test "mark a board" do
    number = 14

    state = %{
      board: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      marked_numbers: [],
      numbers_drawn: []
    }

    updated_state = AdventOfCode.Bingo.mark_board(state, number)

    assert %{
             numbers_drawn: [number, 13],
             marked_numbers: [number, 13],
             board: updated_state.board
           } ==
             AdventOfCode.Bingo.mark_board(updated_state, 13)
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

    assert AdventOfCode.Bingo.is_winning_rows?(state)
  end

  test "board is a winner, matching column" do
    state = %{
      board: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      marked_numbers: [14, 10, 18, 22, 2],
      numbers_drawn: []
    }

    assert AdventOfCode.Bingo.is_winning_columns?(state)
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
    state = %{
      board: [
        [14, 21, 17, 24, 4],
        [10, 16, 15, 9, 19],
        [18, 8, 23, 26, 20],
        [22, 11, 13, 6, 5],
        [2, 0, 12, 3, 7]
      ],
      marked_numbers: [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24],
      numbers_drawn: [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 1337, 21, 24]
    }

    assert 4_512 == AdventOfCode.Bingo.calculate_score(state)
  end
end
