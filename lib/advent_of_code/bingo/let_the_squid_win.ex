defmodule AdventOfCode.Bingo.LetTheSquidWin do
  @moduledoc """
  This is when you realize you are playing against a massive
  squid who's hugging the submarine you are in.

  So you figure out which board is going to win the last,
  avoiding becoming your new amigo's dinner.
  """
  def play do
    numbers = AdventOfCode.Bingo.get_numbers()
    boards = AdventOfCode.Bingo.get_boards()

    find_all_states(numbers, boards)
    |> Enum.at(-1)
    |> AdventOfCode.Bingo.calculate_score()
  end

  def find_all_states(numbers_to_be_drawn, boards) do
    initial_states = Enum.map(boards, &AdventOfCode.Bingo.create_state/1)

    Enum.reduce(numbers_to_be_drawn, initial_states, &play_all/2)
    |> Enum.sort(fn prev, next -> length(prev.numbers_drawn) < length(next.numbers_drawn) end)
  end

  def play_all(drawn_number, states) do
    Enum.map(states, fn state ->
      if AdventOfCode.Bingo.is_winning?(state),
        do: state,
        else: AdventOfCode.Bingo.mark_board(state, drawn_number)
    end)
  end
end
