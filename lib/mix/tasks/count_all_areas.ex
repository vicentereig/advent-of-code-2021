defmodule Mix.Tasks.CountAllAreas do
  @moduledoc "Runs day05 tests`"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    dangerous_areas =
      File.read!("data/day05/input.txt")
      |> String.split("\n")
      |> Enum.filter(fn raw -> raw != "" end)
      |> Enum.map(&AdventOfCode.Segment.parse/1)
      |> AdventOfCode.VentDetector.plot_all_vents()
      |> AdventOfCode.VentDetector.count_dangerous_areas()

    IO.puts("Total dangerous areas: #{dangerous_areas}")
  end
end
