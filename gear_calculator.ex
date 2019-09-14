defmodule GearCalculator do
  @moduledoc """
  Runs calculations on a set of pegs to determine the radius of the first gear that will make the
  RPMs of the last gear double that of the first.
  """

  @doc """
  Determine the fraction representation of the size of the first gear in a series of gears along a
  support beam that will make the last gear rotate at double the RPM of the first gear.
  """
  @spec answer([integer()]) :: [integer()]
  def answer(pegs) when is_list(pegs) do
    [-1, -1]
  end
end
