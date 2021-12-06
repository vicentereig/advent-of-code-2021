defmodule SimfishTest do
  use ExUnit.Case
  doctest AdventOfCode.Simfish
  alias AdventOfCode.Simfish
  use Bitwise

  test "18 days of a single fish" do
    initial_population = [3]
    assert 5 == Simfish.evolve_over(initial_population, 18) |> length
  end

  test "finds 26 fish after 18 days" do
    initial_population = [3, 4, 3, 1, 2]
    assert 26 == Simfish.evolve_over(initial_population, 18) |> length
  end

  test "finds 5934 fish after 80 days" do
    initial_population = [3, 4, 3, 1, 2]
    assert 5934 == Simfish.evolve_over(initial_population, 80) |> length
  end

  @tag :skip
  test "finds 26984457539 fish after 256 days" do
    initial_population = [3, 4, 3, 1, 2]
    assert 26_984_457_539 == Simfish.evolve_over(initial_population, 256) |> length
  end

  describe "encoding generations in bits" do
    test "cycle of a single fish" do
      initial_population = 0x3
      initial_timer_mask = 0x1
      initial_state = %{population: initial_population, timer_mask: initial_timer_mask}

      IO.puts("Initial state: #{Integer.to_string(initial_population, 16)}")

      assert 5 ==
               Enum.reduce(1..18, initial_state, fn day,
                                                    %{
                                                      population: population,
                                                      timer_mask: timer_mask
                                                    } ->
                 pop_parts = String.split(Integer.to_string(population, 16), "0")

                 offspring_size = Enum.count(pop_parts) - 1

                 new_gen =
                   cond do
                     offspring_size > 0 ->
                       new_population = Enum.join(pop_parts, "6")
                       offspring = Enum.map(1..offspring_size, fn _i -> 8 end)
                       with_children = "#{new_population}#{Enum.join(offspring)}"
                       IO.inspect(with_children, label: "new kids")
                       %{population: String.to_integer(with_children, 16), timer_mask: timer_mask + (timer_mask <<< 4)}
                     offspring_size == 0 ->
                       %{population: population - timer_mask, timer_mask: timer_mask}
                   end

                 IO.puts("After #{day} days: #{Integer.to_string(new_gen.population, 16)}")
                 new_gen
               end)
               |> Integer.to_string(16)
               |> String.length()
    end
  end

  test "day06 part 1 - finds 380_758 fish after 18 days" do
    assert 380_758 ==
             File.read!("data/day06/input.txt")
             |> String.split(",")
             |> Enum.map(&String.to_integer/1)
             |> Simfish.evolve_over(80)
             |> length
  end
end
