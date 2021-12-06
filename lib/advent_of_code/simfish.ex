defmodule AdventOfCode.Simfish do
  def evolve_over(initial_population, duration_in_days) do
    Enum.reduce(1..duration_in_days, initial_population, fn _day, population ->
      Enum.flat_map(population, fn fish ->
        cond do
          fish > 0 -> [fish - 1]
          fish == 0 -> [6, 8]
        end
      end)
    end)
  end

  #    [3]
  #    [2]
  #    [1]
  #    [0]
  #    [6, 8]
  #    [5, 7]
  #    [4, 6]
  #    [3, 5]
  #    [2, 4]
  #    [1, 3]
  #    [0, 2]
  #    [6, 8, 1] (0x618)
  #    [5, 7, 0] (0x507)
  #    [4, 6, 6, 8] (0x4668)
  #    [3, 5, 5, 7] 0x3557
  #    [2, 4, 4, 6]
  #    [1, 3, 3, 5]
  #    [0, 2, 2, 4]
  #    [6, 1, 1, 3, 8] 0x61138
  #    [6, 1, 1, 3, 8] 0x61138
  def faster_evolve_over([], 0) do
  end
end
