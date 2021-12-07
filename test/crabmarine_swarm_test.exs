defmodule CrabmarineSwarmTest do
  use ExUnit.Case

  test "naive impl part 1" do
    assert %{
             cost: 37,
             moves: [
               %Crabmarine{from: 0, fuel: 2, to: 2},
               %Crabmarine{from: 1, fuel: 1, to: 2},
               %Crabmarine{from: 1, fuel: 1, to: 2},
               %Crabmarine{from: 2, fuel: 0, to: 2},
               %Crabmarine{from: 2, fuel: 0, to: 2},
               %Crabmarine{from: 2, fuel: 0, to: 2},
               %Crabmarine{from: 4, fuel: 2, to: 2},
               %Crabmarine{from: 7, fuel: 5, to: 2},
               %Crabmarine{from: 14, fuel: 12, to: 2},
               %Crabmarine{from: 16, fuel: 14, to: 2}
             ]
           } == CrabmarineSwarn.create_swarm() |> CrabmarineSwarn.find_cheapest_move()
  end

  test "naive impl part 2" do
    assert %{
             cost: 168,
             moves: [
               %Crabmarine{from: 0, fuel: 15, to: 5},
               %Crabmarine{from: 1, fuel: 10, to: 5},
               %Crabmarine{from: 1, fuel: 10, to: 5},
               %Crabmarine{from: 2, fuel: 6, to: 5},
               %Crabmarine{from: 2, fuel: 6, to: 5},
               %Crabmarine{from: 2, fuel: 6, to: 5},
               %Crabmarine{from: 4, fuel: 1, to: 5},
               %Crabmarine{from: 7, fuel: 3, to: 5},
               %Crabmarine{from: 14, fuel: 45, to: 5},
               %Crabmarine{from: 16, fuel: 66, to: 5}
             ]
           } == CrabmarineSwarn.create_swarm() |> CrabmarineSwarn.find_cheapest_move_v2()
  end

  test "day07 part 1" do
    best_move = CrabmarineSwarn.load_swarm() |> CrabmarineSwarn.find_cheapest_move()
    assert 345_197 == best_move.cost
  end

  test "day07 part 2" do
    best_move = CrabmarineSwarn.load_swarm() |> CrabmarineSwarn.find_cheapest_move_v2()
    assert 96_361_606 == best_move.cost
  end
end
