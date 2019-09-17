defmodule GearCalculator.CLI do
  @moduledoc """
  Command-line interface for the gear calculator.
  """

  import GearCalculator, only: [answer: 1]

  @doc """
  Parse arguments and delegate to the gear calculator.

  Assumes input comes in one line at a team, each line containing a single integer. The integer 0
  indicates the end of pegs, and 0 is not included. Additional error checking has been avoided for
  the sake of simplicity.
  """
  @spec main([String.t()]) :: :ok
  def main(_args \\ []) do
    read_input()
    |> Enum.reverse()
    |> answer()
    |> print()
  end

  # Recursively read input lines and add them to the list of pegs.
  defp read_input(pegs \\ []) do
    peg = "" |> IO.gets() |> String.trim() |> String.to_integer()

    if peg == 0 do
      pegs
    else
      read_input([peg | pegs])
    end
  end

  # Print the numerator / denominator fraction like a list.
  defp print([numerator, denominator]), do: IO.puts("[#{numerator}, #{denominator}]")
end
