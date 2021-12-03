defmodule AdventOfCode.Diagnostics do

  def calculate_co2_scrubber_rating(report) do
    rating = find_co2_scrubber_rating(report)
    String.to_integer(rating, 2)
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

    Enum.reduce_while(iterations, initial_state, fn _iter, state ->
      cond do
        length(state.numbers) == 1 ->
          {:halt, Enum.at(state.numbers, 0)}

        true ->
          new_selected_numbers =
            Enum.filter(state.numbers, fn number ->
              String.at(number, state.index) == state.most_common_bit
            end)

          counts = count_bits(new_selected_numbers)
          cond do
            state.index >= length(counts) ->
              IO.inspect(state)
              {:cont, %{ state | result: String.to_integer(Enum.at(new_selected_numbers, 0), 2)}}

            state.index < length(counts) ->
              next_index = state.index + 1
              {:cont,
                %{
                  numbers: new_selected_numbers,
                  most_common_bit:
                    if(
                      next_index < length(counts) && Enum.at(counts, next_index).ones_count >=
                        Enum.at(counts, next_index).zeros_count,
                      do: "0",
                      else: "1"
                    ),
                  index: state.index + 1,
                  result: nil
                }}
          end
      end
    end)
  end

  def calculate_oxygen_generator_rating(report) do
    rating = find_oxygen_generator_rating(report)
    String.to_integer(rating, 2)
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

    Enum.reduce_while(iterations, initial_state, fn _iter, state ->
      cond do
        length(state.numbers) == 1 ->
          {:halt, Enum.at(state.numbers, 0)}

        true ->
          new_selected_numbers =
            Enum.filter(state.numbers, fn number ->
              String.at(number, state.index) == state.most_common_bit
            end)

          counts = count_bits(new_selected_numbers)
          cond do
            state.index >= length(counts) ->
            IO.inspect(state)
              {:cont, %{ state | result: String.to_integer(Enum.at(new_selected_numbers, 0), 2)}}

            state.index < length(counts) ->
              next_index = state.index + 1
              {:cont,
               %{
                 numbers: new_selected_numbers,
                 most_common_bit:
                   if(
                     next_index < length(counts) && Enum.at(counts, next_index).ones_count >=
                       Enum.at(counts, next_index).zeros_count,
                     do: "1",
                     else: "0"
                   ),
                 index: state.index + 1,
                 result: nil
               }}
          end
      end
    end)
  end

  def calculate_power_consumption(report) do
    counts = count_bits(report)
    gamma_rate = String.to_integer(calculate_gamma_rate(counts), 2)
    epsilon_rate = String.to_integer(calculate_epsilon_rate(counts), 2)
    gamma_rate * epsilon_rate
  end

  def count_bits(report) do
    matrix = Enum.map(report, &String.graphemes/1)
    initial_counts = %{ones_count: 0, zeros_count: 0}

    counts =
      Enum.map(transpose(matrix), fn word ->
        Enum.reduce(word, initial_counts, fn bit, counts ->
          case bit do
            "1" -> Map.put(counts, :ones_count, counts.ones_count + 1)
            "0" -> Map.put(counts, :zeros_count, counts.zeros_count + 1)
          end
        end)
      end)
  end

  def calculate_gamma_rate(counts) do
    Enum.map(counts, fn counts ->
      cond do
        counts.ones_count > counts.zeros_count -> "1"
        true -> "0"
      end
    end)
    |> Enum.join()
  end

  def calculate_epsilon_rate(counts) do
    Enum.map(counts, fn counts ->
      cond do
        counts.ones_count < counts.zeros_count -> "1"
        true -> "0"
      end
    end)
    |> Enum.join()
  end

  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end
