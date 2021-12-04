defmodule AdventOfCode.Bingo do
  def get_numbers do
    []
  end

  def get_boards do
    []
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

  def is_winning?(state) do
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
end
