ExUnit.start()

defmodule GearCalculatorTest do
  use ExUnit.Case

  doctest GearCalculator

  @test_cases [
    %{
      input: [4, 30, 50],
      output: [12, 1],
    },
    %{
      input: [4, 8],
      output: [8, 3],
    },
    %{
      input: [1, 504, 1224],
      output: [-1, -1],
    },
  ]

  test "GearCalculator.answer/1" do
    @test_cases
    |> Enum.each(fn %{input: pegs, output: output} ->
      assert GearCalculator.answer(pegs) == output
    end)
  end
end
