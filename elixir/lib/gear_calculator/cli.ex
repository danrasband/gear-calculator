defmodule GearCalculator.CLI do
  @moduledoc """
  Command-line interface for the gear calculator.
  """

  import GearCalculator, only: [answer: 1]

  @doc """
  Read and validate and delegate to the gear calculator.

  Assumes input comes in one line at a team, each line containing a single integer. The integer 0
  indicates the end of pegs, and 0 is not included. Additional error checking has been avoided for
  the sake of simplicity.
  """
  @spec main([String.t()]) :: :ok
  def main(args \\ []) do
    if length(args) > 0, do: usage!()

    read_input()
    |> validate_and_preprocess!()
    |> answer()
    |> print()
  end

  # Recursively read input lines and add them to the list of pegs.
  defp read_input(pegs \\ []) do
    peg = "" |> IO.gets() |> String.trim()

    if peg == "0" do
      pegs
    else
      read_input([peg | pegs])
    end
  end

  # Print the numerator / denominator fraction like a list.
  defp print([numerator, denominator]), do: IO.puts("[#{numerator}, #{denominator}]")

  defp cast_to_integer!(number) do
    try do
      String.to_integer(number)
    rescue
      ArgumentError -> usage!()
    end
  end

  def validate_and_preprocess!(pegs) do
    if length(pegs) == 0, do: usage!()

    pegs
    |> Enum.map(&cast_to_integer!/1)
    |> Enum.reverse()
  end

  def usage! do
    IO.puts(:stderr, """
Usage: ./gear_calculator

  After invoking the gear_calculator program, type the position of each peg,
  followed by [ENTER]. When you have entered all the peg positions, enter 0,
  then [ENTER].
""")
    Process.exit(self(), :kill)
  end
end
