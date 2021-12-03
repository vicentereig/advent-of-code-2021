defmodule AdventOfCode.Diagnostics do
  @moduledoc """
  This module models Diagnostic tooling
  """
  @moduledoc since: "1.0.0"
  def calculate_lifer_support_rating(report) do
    calculate_co2_scrubber_rating(report) * calculate_oxygen_generator_rating(report)
  end

  def calculate_co2_scrubber_rating(report) do
    rating = find_co2_scrubber_rating(report)
    String.to_integer(rating, 2)
  end

  def co2_scrubber_rating_finder(_iter, state) do
    cond do
      length(state.numbers) == 1 ->
        {:halt, Enum.at(state.numbers, 0)}

      length(state.numbers) > 1 ->
        new_selected_numbers =
          Enum.filter(state.numbers, fn number ->
            String.at(number, state.index) == state.most_common_bit
          end)

        counts = count_bits(new_selected_numbers)

        cond do
          state.index >= length(counts) ->
            {:cont, %{state | result: String.to_integer(Enum.at(new_selected_numbers, 0), 2)}}

          state.index < length(counts) ->
            next_index = state.index + 1

            {:cont,
             %{
               numbers: new_selected_numbers,
               most_common_bit:
                 if(
                   next_index < length(counts) &&
                     Enum.at(counts, next_index).ones_count >=
                       Enum.at(counts, next_index).zeros_count,
                   do: "0",
                   else: "1"
                 ),
               index: state.index + 1,
               result: nil
             }}
        end
    end
  end

  def find_co2_scrubber_rating(report) do
    counts = count_bits(report)

    initial_state = %{
      numbers: report,
      most_common_bit:
        if(Enum.at(counts, 0).ones_count >= Enum.at(counts, 0).zeros_count,
          do: "0",
          else: "1"
        ),
      index: 0,
      rate: nil
    }

    last_iteration = length(report) * String.length(Enum.at(report, 0)) - 1
    iterations = 0..last_iteration

    Enum.reduce_while(iterations, initial_state, &co2_scrubber_rating_finder/2)
  end

  def calculate_oxygen_generator_rating(report) do
    rating = find_oxygen_generator_rating(report)
    String.to_integer(rating, 2)
  end

  def oxygen_gen_rating_finder(_iter, state) do
    cond do
      length(state.numbers) == 1 ->
        {:halt, Enum.at(state.numbers, 0)}

      length(state.numbers) > 1 ->
        new_selected_numbers =
          Enum.filter(state.numbers, fn number ->
            String.at(number, state.index) == state.most_common_bit
          end)

        counts = count_bits(new_selected_numbers)

        cond do
          state.index >= length(counts) ->
            {:cont, %{state | result: String.to_integer(Enum.at(new_selected_numbers, 0), 2)}}

          state.index < length(counts) ->
            next_index = state.index + 1

            {:cont,
             %{
               numbers: new_selected_numbers,
               most_common_bit:
                 if(
                   next_index < length(counts) &&
                     Enum.at(counts, next_index).ones_count >=
                       Enum.at(counts, next_index).zeros_count,
                   do: "1",
                   else: "0"
                 ),
               index: state.index + 1,
               result: nil
             }}
        end
    end
  end

  def find_oxygen_generator_rating(report) do
    counts = count_bits(report)

    initial_state = %{
      numbers: report,
      most_common_bit:
        if(Enum.at(counts, 0).ones_count >= Enum.at(counts, 0).zeros_count,
          do: "1",
          else: "0"
        ),
      index: 0,
      rate: nil
    }

    last_iteration = length(report) * String.length(Enum.at(report, 0)) - 1
    iterations = 0..last_iteration

    Enum.reduce_while(iterations, initial_state, &oxygen_gen_rating_finder/2)
  end

  def calculate_power_consumption(report) do
    counts = count_bits(report)
    gamma_rate = String.to_integer(calculate_gamma_rate(counts), 2)
    epsilon_rate = String.to_integer(calculate_epsilon_rate(counts), 2)
    gamma_rate * epsilon_rate
  end

  @doc ~S"""
  Calculates gamma rate

  ## Examples

    iex> AdventOfCode.Diagnostics.count_bits(["0011", "1100"])
    [%{ones_count: 1, zeros_count: 1},%{ones_count: 1, zeros_count: 1},%{ones_count: 1, zeros_count: 1},%{ones_count: 1, zeros_count: 1}]
  """
  def count_bits(report) do
    matrix = Enum.map(report, &String.graphemes/1)
    Enum.map(transpose(matrix), &count_bits_in_word/1)
  end

  @doc ~S"""
  Calculates gamma rate

  ## Examples

    iex> AdventOfCode.Diagnostics.count_bits_in_word(["0", "0", "1", "1"])
    %{ones_count: 2, zeros_count: 2}
  """
  def count_bits_in_word(word) do
    initial_counts = %{ones_count: 0, zeros_count: 0}

    Enum.reduce(word, initial_counts, fn bit, counts ->
      case bit do
        "1" -> Map.put(counts, :ones_count, counts.ones_count + 1)
        "0" -> Map.put(counts, :zeros_count, counts.zeros_count + 1)
      end
    end)
  end

  @doc ~S"""
  Calculates gamma rate

  ## Examples

    iex> AdventOfCode.Diagnostics.calculate_gamma_rate([%{ones_count: 1, zeros_count: 2}, %{ones_count: 2, zeros_count: 1} ])
    "01"
  """
  def calculate_gamma_rate(counts) do
    Enum.map_join(counts, fn counts ->
      if counts.ones_count > counts.zeros_count, do: "1", else: "0"
    end)
  end

  @doc ~S"""
  Calculates epsilon rate

  ## Examples

    iex> AdventOfCode.Diagnostics.calculate_epsilon_rate([%{ones_count: 1, zeros_count: 2}, %{ones_count: 2, zeros_count: 1} ])
    "10"
  """
  def calculate_epsilon_rate(counts) do
    Enum.map_join(counts, fn counts ->
      if counts.ones_count < counts.zeros_count, do: "1", else: "0"
    end)
  end

  @doc ~S"""
  Transposes a vector or a matrix

  ## Examples

    iex> AdventOfCode.Diagnostics.transpose([[1,1]])
    [[1], [1]]


    iex> AdventOfCode.Diagnostics.transpose([[1,1], [2,2], [3,3]])
    [[1,2,3], [1,2,3]]
  """
  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end
