defmodule AdventOfCode.Bingo do
  @moduledoc """
  Bingo subsystem - This module by default will beat the Squid.
  """
  @moduledoc since: "1.0.0"

  def calculate_score(%{
        board: board,
        numbers_drawn: numbers_drawn,
        marked_numbers: marked_numbers
      }) do
    unmarked_numbers_scores =
      Enum.map(board, fn row ->
        Enum.filter(row, fn number -> not Enum.member?(marked_numbers, number) end)
        |> Enum.sum()
      end)

    Enum.sum(unmarked_numbers_scores) * List.last(numbers_drawn)
  end

  def create_state(board, marked_numbers \\ [], numbers_drawn \\ []),
    do: %{
      board: board,
      marked_numbers: marked_numbers,
      numbers_drawn: numbers_drawn
    }

  def get_numbers do
    [numbers | _] = File.read!("data/day04/input.txt") |> String.split("\n")

    numbers
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def get_boards do
    [_ | raw_boards] = File.read!("data/day04/input.txt") |> String.split("\n")

    Enum.chunk_every(raw_boards, 6)
    |> Enum.map(&parse_board/1)
  end

  def parse_board(raw_board) do
    Enum.filter(raw_board, fn row -> row != "" end)
    |> Enum.map(fn raw_numbers ->
      String.split(raw_numbers)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def play do
    numbers = get_numbers()
    boards = get_boards()
    find_winning_board(numbers, boards)
  end

  def find_winning_board(numbers, boards) do
    initial_states = Enum.map(boards, &create_state/1)

    Enum.reduce_while(numbers, initial_states, &play_round/2)
    |> calculate_score
  end

  def play_round(number, states) do
    updated_states = Enum.map(states, fn state -> mark_board(state, number) end)

    case find_winning_state(updated_states) do
      {:ok, winning_state} -> {:halt, winning_state}
      {:fail} -> {:cont, updated_states}
    end
  end

  def find_winning_state(states) do
    case Enum.filter(states, fn state -> is_winning?(state) end) do
      [] -> {:fail}
      [state | []] -> {:ok, state}
    end
  end

  def is_winning?(state), do: any_winning_columns?(state) || any_winning_rows?(state)

  def any_winning_columns?(state) do
    marked_set = MapSet.new(Map.get(state, :marked_numbers, []))

    Enum.any?(AdventOfCode.Matrix.transpose(state.board), fn row ->
      row_set = MapSet.new(row)
      MapSet.size(marked_set) > 0 and MapSet.subset?(row_set, marked_set)
    end)
  end

  def any_winning_rows?(state) do
    marked_set = MapSet.new(Map.get(state, :marked_numbers, []))

    Enum.any?(state.board, fn row ->
      row_set = MapSet.new(row)
      MapSet.size(marked_set) > 0 and MapSet.subset?(row_set, marked_set)
    end)
  end

  def mark_board(state, number) do
    state
    |> Map.put(:numbers_drawn, (state.numbers_drawn || []) ++ [number])
    |> Map.put(
      :marked_numbers,
      (state.marked_numbers || []) ++ find_marked_numbers(state.board, [number])
    )
  end

  def find_marked_numbers(board, numbers_drawn) do
    Enum.map(board, fn row ->
      row_set = MapSet.new(row)
      drawn_set = MapSet.new(numbers_drawn)
      MapSet.intersection(row_set, drawn_set)
    end)
    |> Enum.filter(fn set -> MapSet.size(set) > 0 end)
    |> Enum.reduce(MapSet.new(), fn set, sets ->
      MapSet.union(sets, set)
    end)
    |> MapSet.to_list()
  end
end
