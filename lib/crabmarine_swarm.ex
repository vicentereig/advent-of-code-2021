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
    %Crabmarine{to: max_position} = Enum.max_by(all_crabs, fn c -> c.to end)

    0..max_position
    |> Enum.map(fn destination ->
      all_crabs
      |> Enum.map(fn other -> Crabmarine.move(other, destination) end)
    end)
    |> Enum.reduce([], fn moves, states ->
      cost = Enum.map(moves, fn m -> m.fuel end) |> Enum.sum()
      states ++ [%{moves: moves, cost: cost}]
    end)
    |> Enum.min_by(fn c -> c.cost end)
  end

  def find_cheapest_move_v2(all_crabs) do
    %Crabmarine{to: max_position} = Enum.max_by(all_crabs, fn c -> c.to end)

    0..max_position
    |> Enum.map(fn destination ->
      moves = Enum.map(all_crabs, fn other -> Crabmarine.move_v2(other, destination) end)
      cost = Enum.map(moves, fn m -> m.fuel end) |> Enum.sum()
      %{moves: moves, cost: cost}
    end)
    |> Enum.min_by(fn c -> c.cost end)
  end
end
