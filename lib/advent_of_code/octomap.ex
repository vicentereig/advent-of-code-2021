defmodule AdventOfCode.Octomap do
  defstruct x: 0, y: 0, energy: 0, flashed: false
  alias AdventOfCode.Octomap

  def create_octomap(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn raw ->
      raw
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> to_map
  end

  def to_map(energy_map) do
    energy_map
    |> Enum.with_index()
    |> Enum.map(fn {row, x} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {e, y} ->
        %Octomap{x: x, y: y, energy: e}
      end)
    end)
  end

  # recharge all
  # flash all 9s, propagate to non-zeros
  # flash new 9s, propagate to non-zeros
  def next_octomap(map) do
    map
    |> recharge
    |> flash
    |> propagate_energy
    |> flash
    |> propagate_energy
  end

  def recharge(map) do
    map
    |> Octomap.map(fn %Octomap{x: x, y: y, energy: e, flashed: f} ->
      %Octomap{x: x, y: y, energy: e + 1, flashed: f}
    end)
  end

  def map(map, f) do
    map |> Enum.map(fn row -> row |> Enum.map(fn octopus -> f.(octopus) end) end)
  end

  def flash(map) do
    map
    |> Octomap.map(fn %Octomap{x: x, y: y, energy: e, flashed: flashed} = octopus ->
      if e >= 9 do
        %Octomap{x: x, y: y, energy: 0, flashed: !flashed}
      else
        octopus
      end
    end)
  end

  def propagate_energy(map) do
    map
    |> Octomap.map(fn %Octomap{energy: e} = octopus ->
      if e == 0 do
        %{octopus | flashed: false}
      else
        absorbed_energy =
          map
          |> did_they_flash?(octopus)
          |> Enum.count(fn neighbour_flashed -> neighbour_flashed == true end)

        %{octopus | flashed: false, energy: e + absorbed_energy}
      end
    end)
  end

  def did_they_flash?(map, octopus) do
    [
      upper_flashed?(map, octopus),
      lower_flashed?(map, octopus),
      left_flashed?(map, octopus),
      right_flashed?(map, octopus),
      upper_left_flashed?(map, octopus),
      upper_right_flashed?(map, octopus),
      lower_left_flashed?(map, octopus),
      lower_right_flashed?(map, octopus)
    ]
  end

  def to_flashed(nil), do: false

  def to_flashed(%Octomap{flashed: flashed}), do: flashed

  def upper_flashed?(map, %Octomap{x: x, y: y}) do
    if x - 1 < 0, do: false, else: map |> Enum.at(x - 1) |> Enum.at(y) |> to_flashed
  end

  def lower_flashed?(map, %Octomap{x: x, y: y}) do
    if x + 1 >= length(map), do: false, else: map |> Enum.at(x + 1) |> Enum.at(y) |> to_flashed
  end

  def left_flashed?(map, %Octomap{x: x, y: y}) do
    if x - 1 < 0 or y - 1 < 0, do: false, else: map |> Enum.at(x) |> Enum.at(y - 1) |> to_flashed
  end

  def right_flashed?(map, %Octomap{x: x, y: y}) do
    if x > length(map), do: false, else: map |> Enum.at(x) |> Enum.at(y + 1) |> to_flashed
  end

  def upper_left_flashed?(map, %Octomap{x: x, y: y}) do
    if x - 1 < 0 or y - 1 < 0,
      do: false,
      else: map |> Enum.at(x - 1) |> Enum.at(y - 1) |> to_flashed
  end

  def upper_right_flashed?(map, %Octomap{x: x, y: y}) do
    if x - 1 < 0, do: false, else: map |> Enum.at(x - 1) |> Enum.at(y + 1) |> to_flashed
  end

  def lower_left_flashed?(map, %Octomap{x: x, y: y}) do
    if x + 1 >= length(map) or y - 1 < 0,
      do: false,
      else: map |> Enum.at(x + 1) |> Enum.at(y - 1) |> to_flashed
  end

  def lower_right_flashed?(map, %Octomap{x: x, y: y}) do
    if x + 1 >= length(map),
      do: false,
      else: map |> Enum.at(x + 1) |> Enum.at(y + 1) |> to_flashed
  end

  def to_energy(nil), do: nil
  def to_energy(%Octomap{energy: e}), do: e
end
