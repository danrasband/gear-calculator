defmodule GearCalculator.CLI do
  @moduledoc """
  Command-line interface for the gear calculator.
  """

  import GearCalculator, only: [answer: 1]

  @doc "Parse arguments and delegate to the gear calculator."
  @spec main([String.t()]) :: :ok
  def main(_args \\ []) do
    read_input()
    |> Enum.reverse()
    |> answer()
    |> IO.inspect()
  end

  defp read_input(pegs \\ []) do
    peg = "" |> IO.gets() |> String.trim() |> String.to_integer()

    if peg == 0 do
      pegs
    else
      read_input([peg | pegs])
    end
  end
end
