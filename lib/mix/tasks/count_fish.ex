defmodule Mix.Tasks.CountFish do
  @moduledoc "Runs day06 tests`"
  alias AdventOfCode.Simfish

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    fish_count = File.read!("data/day06/input.txt")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> IO.inspect
    |> Simfish.evolve_over(256)
    |> length
    IO.puts("Total fish over 256 days: #{fish_count}")
  end
end
