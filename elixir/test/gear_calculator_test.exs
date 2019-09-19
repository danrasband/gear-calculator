defmodule GearCalculatorTest do
  @moduledoc """
  Test the core gear calculator functionality.
  """

  use ExUnit.Case

  doctest GearCalculator

  @test_cases [
    %{
      input: [4, 30, 50],
      output: [12, 1]
    },
    %{
      input: [4, 8],
      output: [8, 3]
    },
    %{
      input: [1, 504, 1224],
      output: [-1, -1]
    },
    %{
      input: [100, 105, 115, 225, 300, 350],
      output: [-1, -1]
    },
    %{
      input: [1, 15, 39, 55, 73, 89],
      output: [8, 3]
    },
    %{
      input: [3, 40, 50],
      output: [-1, -1]
    },
    %{
      input: [30, 40, 45],
      output: [-1, -1]
    },
    %{
      input: [30, 50, 50],
      output: [-1, -1]
    }
  ]

  test "GearCalculator.answer/1" do
    @test_cases
    |> Enum.each(fn %{input: pegs, output: output} ->
      assert GearCalculator.answer(pegs) == output
    end)
  end
end
