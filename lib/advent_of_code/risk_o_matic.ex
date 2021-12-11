defmodule AdventOfCode.RiskOMatic do
  @moduledoc """
  Subsystem to assess the risk of a lava tube
  """
  def create_heightmap(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn r -> r |> Enum.map(&String.to_integer/1) end)
  end

  def get_height_at(heightmap, x, y) do
    if Enum.member?(0..(length(heightmap) - 1), x) and
         Enum.member?(0..(length(Enum.at(heightmap, x)) - 1), y),
       do: Enum.at(heightmap, x) |> Enum.at(y),
       else: :infinity
  end

  def find_low_points(heightmap) do
    heightmap
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, x} ->
      row
      |> Enum.with_index()
      |> Enum.filter(fn {height, y} ->
        height < get_height_at(heightmap, x, y - 1) and
          height < get_height_at(heightmap, x, y + 1) and
          height < get_height_at(heightmap, x + 1, y) and
          height < get_height_at(heightmap, x - 1, y)
      end)
      |> Enum.map(fn {height, _} -> height end)
    end)
  end

  def calculate_risk_levels(lower_heights) do
    lower_heights
    |> Enum.map(&(&1 + 1))
  end

  def solve_part1(input) do
    input
    |> create_heightmap
    |> find_low_points
    |> calculate_risk_levels
    |> Enum.sum()
  end
end
