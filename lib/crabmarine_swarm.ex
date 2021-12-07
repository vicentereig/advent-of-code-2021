defmodule CrabmarineSwarn do
  @moduledoc """
    Models a bunch of submarines piloted by crabs.
  """
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

  def find_cheapest_move(all_crabs) do
    {
      %Crabmarine{to: min_to, from: _min_from, fuel: _min_fuel},
      %Crabmarine{to: max_to, from: _max_from, fuel: _max_fuel}
    } = Enum.min_max_by(all_crabs, fn c -> c.to end)

    min_to..max_to
    |> Enum.map(fn destination ->
      moves = Enum.map(all_crabs, fn crab -> Crabmarine.move(crab, destination) end)
      cost = Enum.map(moves, fn m -> m.fuel end) |> Enum.sum()
      %{moves: moves, cost: cost}
    end)
    |> Enum.min_by(fn c -> c.cost end)
  end

  def find_cheapest_move_v2(all_crabs) do
    {%Crabmarine{to: min_to, from: _min_from, fuel: _min_fuel},
     %Crabmarine{to: max_to, from: _max_from, fuel: _max_fuel}} =
      Enum.min_max_by(all_crabs, fn c -> c.to end)

    min_to..max_to
    |> Enum.map(fn destination ->
      moves = Enum.map(all_crabs, fn crab -> Crabmarine.move_v2(crab, destination) end)
      cost = Enum.map(moves, fn m -> m.fuel end) |> Enum.sum()
      %{moves: moves, cost: cost}
    end)
    |> Enum.min_by(fn c -> c.cost end)
  end
end
