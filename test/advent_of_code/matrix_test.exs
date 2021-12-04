defmodule MatrixTest do
  use ExUnit.Case
  doctest AdventOfCode.Matrix

  test 'turns rows into columns' do
    matrix = [
      [22, 13, 17, 11, 0],
      [8, 2, 23, 4, 24],
      [21, 9, 14, 16, 7],
      [6, 10, 3, 18, 5],
      [1, 12, 20, 15, 19]
    ]

    assert [
             [22, 8, 21, 6, 1],
             [13, 2, 9, 10, 12],
             [17, 23, 14, 3, 20],
             [11, 4, 16, 18, 15],
             [0, 24, 7, 5, 19]
           ] == AdventOfCode.Matrix.transpose(matrix)
  end
end
