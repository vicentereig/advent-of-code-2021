defmodule AdventOfCode.Octomap do
  defstruct x: 0, y: 0, energy: 0
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
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {e, x} ->
        %Octomap{x: x, y: y, energy: e}
      end)
    end)
  end

  # flash all 9s, propagate to non-zeros
  # flash new 9s, propagate to non-zeros
  # increase all non-zero in 1
  def next_octomap(map) do
    map
    |> flash_niners
    |> propagate_energy
    #    flash_niners(map)
    #    |> propagate_energy
    #    recharge(map)
  end

  def map(map, f) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn octopus ->
        f.(octopus)
      end)
    end)
  end

  def flash_niners(map) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn %Octomap{x: x, y: y, energy: e} = octopus ->
        if e == 9 do
          %Octomap{x: x, y: y, energy: 0}
        else
          octopus
        end
      end)
    end)
  end

  def propagate_energy(map) do
    map
    |> Enum.map(fn row ->
      row
      |> Enum.map(fn %Octomap{x: x, y: y, energy: e} = octopus ->
        IO.inspect([x,y], label: "(x,y)")
        flashes = [
          upper_flashed?(map, octopus),
          lower_flashed?(map, octopus),
          left_flashed?(map, octopus),
          right_flashed?(map, octopus),
          upper_left_flashed?(map, octopus),
          upper_right_flashed?(map, octopus),
          lower_left_flashed?(map, octopus),
          lower_right_flashed?(map, octopus)
        ] |> IO.inspect

        irradiated_energy = flashes |> Enum.count(fn flashed -> flashed == true end)
        new_energy = e + irradiated_energy

        %Octomap{x: x, y: y, energy: new_energy}
      end)
    end)
  end

  def upper_flashed?(map, %Octomap{x: x, y: y}) do
    if y < 0, do: false, else: 0 == map |> Enum.at(y - 1) |> Enum.at(x)
  end

  def lower_flashed?(map, %Octomap{x: x, y: y}) do
    if y + 1 >= length(map), do: false, else: 0 == map |> Enum.at(y + 1) |> Enum.at(x)
  end

  def left_flashed?(map, %Octomap{x: x, y: y}) do
    if x - 1 < 0, do: false, else: 0 == map |> Enum.at(y) |> Enum.at(x - 1)
  end

  def right_flashed?(map, %Octomap{x: x, y: y}) do
    if y <= length(map), do: false, else: 0 == map |> Enum.at(y) |> Enum.at(x + 1)
  end

  def upper_left_flashed?(map, %Octomap{x: x, y: y}) do
    if y-1 < 0, do: false, else: 0 == map |> Enum.at(y - 1) |> Enum.at(x - 1)
  end

  def upper_right_flashed?(map, %Octomap{x: x, y: y}) do
    if y-1 < 0, do: false, else: 0 == map |> Enum.at(y - 1) |> Enum.at(x + 1)
  end

  def lower_left_flashed?(map, %Octomap{x: x, y: y}) do
    if y+1 >= length(map), do: false, else: 0 == map |> Enum.at(y + 1) |> Enum.at(x - 1)
  end

  def lower_right_flashed?(map, %Octomap{x: x, y: y}) do
    if y+1 >= length(map), do: false, else: 0 == map |> Enum.at(y + 1) |> Enum.at(x + 1)
  end
end
