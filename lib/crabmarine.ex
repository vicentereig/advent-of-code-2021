defmodule Crabmarine do
  @moduledoc """
    Models a submarine piloted by a crab.
  """
  defstruct from: 0, to: 0, fuel: 0

  def move(%Crabmarine{to: to}, new_to) do
    %Crabmarine{from: to, to: new_to, fuel: abs(to - new_to)}
  end

  @doc """
  iex> Crabmarine.move_v2(%Crabmarine{from: 0, to: 16}, 5)
  %Crabmarine{fuel: 66, from: 16, to: 5}
  """
  def move_v2(%Crabmarine{to: to}, new_to) do
    units_consumed_per_step = Enum.with_index(to..new_to, fn _, index -> index end)
    %Crabmarine{from: to, to: new_to, fuel: Enum.sum(units_consumed_per_step)}
  end

  def create(to, fuel \\ 0) do
    %Crabmarine{to: to, fuel: fuel}
  end
end
