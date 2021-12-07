defmodule Crabmarine do
  defstruct from: 0, to: 0, fuel: 0

  def move(%Crabmarine{to: to}, new_to) do
    %Crabmarine{from: to, to: new_to, fuel: abs(to - new_to)}
  end

  def create(to, fuel \\ 0) do
    %Crabmarine{to: to, fuel: fuel}
  end
end

defmodule CrabmarineSwarn do
  def create_swarm do
    [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]
    |> Enum.sort()
    |> Enum.map(&Crabmarine.create/1)
  end

  def load_swarm do
    File.read!("data/day07/input.txt")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.map(&Crabmarine.create/1)
  end

  def are_aligned?(crabmarines) do
    1 ==
      Enum.uniq_by(crabmarines, fn c -> c.to end)
      |> Enum.count()
  end

  def find_cheapest_move(all_crabs) do
    Enum.with_index(all_crabs)
    |> Enum.map(fn {crab, index} ->
      List.delete_at(all_crabs, index)
      |> Enum.map(fn other -> Crabmarine.move(other, crab.to) end)
    end)
    |> Enum.reduce([], fn moves, states ->
      cost = Enum.map(moves, fn m -> m.fuel end) |> Enum.sum()
      states ++ [%{moves: moves, cost: cost}]
    end)
    |> Enum.min_by(fn c -> c.cost end)
  end
end

defmodule CrabmarineTest do
  use ExUnit.Case

  test "are aligned" do
    crabs = [Crabmarine.create(10), Crabmarine.create(10)]
    assert CrabmarineSwarn.are_aligned?(crabs)
  end

  test "naive impl" do
    assert %{
             cost: 37,
             moves: [
               %Crabmarine{from: 0, fuel: 2, to: 2},
               %Crabmarine{from: 1, fuel: 1, to: 2},
               %Crabmarine{from: 1, fuel: 1, to: 2},
               %Crabmarine{from: 2, fuel: 0, to: 2},
               %Crabmarine{from: 2, fuel: 0, to: 2},
               %Crabmarine{from: 4, fuel: 2, to: 2},
               %Crabmarine{from: 7, fuel: 5, to: 2},
               %Crabmarine{from: 14, fuel: 12, to: 2},
               %Crabmarine{from: 16, fuel: 14, to: 2}
             ]
           } == CrabmarineSwarn.create_swarm() |> CrabmarineSwarn.find_cheapest_move()
  end

  test "day07 part 1" do
    best_move = CrabmarineSwarn.load_swarm() |> CrabmarineSwarn.find_cheapest_move()
    assert 345_197 == best_move.cost
  end
end
