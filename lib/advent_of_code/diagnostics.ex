defmodule AdventOfCode.Diagnostics do
  def calculate_power_consumption(report) do
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

    gamma_rate = String.to_integer(calculate_gamma_rate(counts),2)
    epsilon_rate = String.to_integer(calculate_epsilon_rate(counts), 2)
    gamma_rate * epsilon_rate
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
