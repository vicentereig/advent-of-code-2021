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
      |> Enum.with_index(fn height, y -> %{x: x, y: y, height: height} end)
      |> Enum.filter(fn %{height: height, y: y} ->
        height < get_height_at(heightmap, x, y - 1) and
          height < get_height_at(heightmap, x, y + 1) and
          height < get_height_at(heightmap, x + 1, y) and
          height < get_height_at(heightmap, x - 1, y)
      end)
    end)
  end

  def calculate_risk_levels(lower_heights) do
    lower_heights
    |> Enum.map(&(&1 + 1))
  end

  def find_basins(heightmap, basin_starting_points) do
    basin_starting_points
    |> Enum.map(fn %{x: x, y: y, height: height} = basin_starting_point ->
      [
        %{height: get_height_at(heightmap, x, y + 1), x: x, y: y + 1},
        %{height: get_height_at(heightmap, x, y - 1), x: x, y: y - 1},
        %{height: get_height_at(heightmap, x - 1, y), x: x - 1, y: y},
        %{height: get_height_at(heightmap, x + 1, y), x: x + 1, y: y}
      ]
      |> Enum.filter(fn %{height: h} -> h != :infinity and h != 9 and h > height end)
      |> then(fn next_points -> find_basins(heightmap, next_points) end)
      |> List.flatten()
      |> then(fn basin_tail -> [basin_starting_point] ++ basin_tail end)
      |> MapSet.new()
      |> MapSet.to_list()
      |> Enum.sort_by(fn %{height: h} -> h end)
    end)
  end

  def solve_part2(basins) do
    basins
    |> Enum.map(&length/1)
    |> Enum.sort_by(fn l -> -l end)
    |> Enum.slice(0, 3)
    |> Enum.product()
  end

  def solve_part1(input) do
    input
    |> create_heightmap
    |> find_low_points
    |> Enum.map(fn %{height: height} -> height end)
    |> calculate_risk_levels
    |> Enum.sum()
  end
end
