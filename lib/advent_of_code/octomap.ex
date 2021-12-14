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

  def count_flashes_over_steps(initial_map, step_count) do
    initial_map |> Octomap.map(&to_energy/1) |> IO.inspect()

    1..step_count
    |> Enum.map_reduce(initial_map, fn step, map ->
      next = map |> next_octomap
      next |> Octomap.map(&to_energy/1) |> IO.inspect(label: "Step #{step}")

      flash_count =
        next
        |> Octomap.count(fn %Octomap{energy: e} -> e == 0 end)
        |> IO.inspect(label: "Step #{step}")

      {flash_count, next}
    end)
    |> then(fn {flash_counts, _} -> flash_counts end)
    |> Enum.sum()
  end

  def count(map, f) do
    map
    |> Enum.map(fn row -> row |> Enum.count(fn octopus -> f.(octopus) end) end)
    |> Enum.sum()
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

  def _next_octomap(initial_map) do
    Stream.resource(
    fn ->
        map = initial_map
        |> recharge

        map |> count(fn %Octomap{energy: e} -> e > 9 end) |> IO.inspect(label: "start_count")
        map
    end, # start_fun
    fn prev_map -> #next_fun
      map = prev_map
      |> flash
      |> propagate_energy

      map |> Octomap.map(&Octomap.to_energy/1) |> IO.inspect
      next_map = map |> mark_flashed

      case map |> count(fn %Octomap{flashed: did_flash} -> did_flash end) |> IO.inspect(label: "next_count") do
        0 -> {:halt, nil }
        n -> {next_map, next_map}
      end
    end,
    fn _ -> {} end # after_fun
    )
  end


  def mark_flashed(map) do
    map
    |> Octomap.map(fn octopus -> %{octopus | flashed: false } end)
  end

  def next_octomap(initial_map) do
    initial_map
    |> recharge
    |> Stream.unfold(fn
      [] -> nil
      map ->
        next_map = map |> flash |> propagate_energy
        map |> count(fn %Octomap{flashed: did_flash} -> did_flash end) |> IO.inspect
        case map |> count(fn %Octomap{flashed: did_flash} -> did_flash end) do
          0 -> {next_map |> flash |> mark_flashed , []}
          n -> {next_map |> mark_flashed, next_map |> mark_flashed}
        end
    end)
  end

  def recharge(map) do
    map
    |> Octomap.map(fn %Octomap{x: x, y: y, energy: e, flashed: f} ->
      %Octomap{x: x, y: y, energy: e + 1, flashed: f}
    end)
  end

  def map(map, f) do
    map
    |> Enum.map(fn row -> row
                          |> Enum.map(fn octopus -> f.(octopus) end)
    end)
  end

  # an octopus can only flash once per step
  def flash(map) do
    map
    |> Octomap.map(fn %Octomap{x: x, y: y, energy: e, flashed: flashed} = octopus ->
      if e > 9 and not flashed do
        %Octomap{x: x, y: y, energy: 0, flashed: true}
      else
        octopus
      end
    end)
  end

  def propagate_energy(map) do
    map
    |> Octomap.map(fn %Octomap{energy: e} = octopus ->
      if e == 0 do
        octopus
      else
        absorbed_energy =
          map
          |> did_they_flash?(octopus)
          |> Enum.count(fn neighbour_flashed -> neighbour_flashed == true end)

        %{octopus | energy: e + absorbed_energy}
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
