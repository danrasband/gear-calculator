defmodule GearCalculator do
  @moduledoc """
  Runs calculations on a set of pegs to determine the radius of the first gear that will make the
  RPMs of the last gear double that of the first.
  """

  # The minimum radius of the first gear is 1.
  @minimum_radius_first_gear 1

  # The minimum radius of any radius is 0.5. This assumption is made based on the fact that the
  # first gear's radius must be twice the size of the last gear's radius, and the first radius can't
  # be any smaller than 1. That indicates that the last gear's radius could be 0.5 units, and if it
  # can be 0.5 units, then why not the other gears?
  @minimum_radius_all_gears 0.5

  @doc """
  Determine the fraction representation of the size of the first gear in a series of gears along a
  support beam that will make the last gear rotate at double the RPM of the first gear.
  """
  @spec answer([integer()]) :: [integer()]
  def answer(pegs) do
    distances = distances_between(pegs)
    {constant, coefficient} = calculate_coefficient_and_constant(distances)

    [constant * 2, (1 - coefficient) * 2]
    |> validate(distances)
    |> ideal_form()
  end

  # Recursively calculates the coefficient of an unknown gear radius and the constant that goes
  # along with it.
  #
  # This version of the function represents the last gear in the sequence
  #
  #   x_n = y_n - 0.5 * x_1,
  #
  # where the constant = y_n and the coefficient is -0.5.
  defp calculate_coefficient_and_constant([distance]), do: {distance, -0.5}

  # Initiates and continues the recursion of calculating the constant and coefficient in a system of
  # simple linear equations. This helps solve systems of equations like the following:
  #
  #   x_1 + x_2 = y_1
  #   x_2 + x_3 = y_2
  #   ...
  #   x_n + 0.5 * x_1 = y_n
  #
  # And this part of the function handles everything up until the last equation.
  defp calculate_coefficient_and_constant([distance | other]) do
    {constant, coefficient} = calculate_coefficient_and_constant(other)

    {distance - constant, -coefficient}
  end

  # Calculate the distances between pegs.
  defp distances_between(pegs) do
    pegs
    |> Enum.reduce({[], nil}, &reduce_peg_distances/2)
    |> elem(0)
    |> Enum.reverse()
  end

  # Calculate the distances between the pages
  defp reduce_peg_distances(peg, {distances, prev_peg} = data) do
    if is_nil(prev_peg) do
      data |> put_elem(1, peg)
    else
      data
      |> put_elem(0, [peg - prev_peg | distances])
      |> put_elem(1, peg)
    end
  end

  # If the denominator of the fraction is 1, it can't be simplified further, so just return as is.
  defp ideal_form([numerator, 1]), do: [trunc(numerator), 1]

  # Reduce the fraction until it can't be reduced any further.
  defp ideal_form([numerator, denominator]) do
    numerator = trunc(numerator)
    denominator = trunc(denominator)

    numerator
    |> Integer.gcd(denominator)
    |> case do
      1 -> [numerator, denominator]
      divisor -> ideal_form([numerator / divisor, denominator / divisor])
    end
  end

  # Validate that the first gear's radius is valid. It is a valid radius if it is greater than or
  # equal to 1 and all of the subsequent gears evaluate to greatur than or equal to 0.5.
  #
  # Returns [-1, -1] if invalid, otherwise the original radius fraction as list: [n, d].
  defp validate([numerator, denominator], distances) do
    first_gear_radius = numerator / denominator

    distances
    |> check_each_gear(first_gear_radius)
    |> case do
      {_, false} -> [-1, -1]
      _ -> [numerator, denominator]
    end
  end

  # The radius of the last gear is the distance between its peg and the previous peg minus half of
  # the first gear's radius.
  #
  # z = distance - 0.5x
  defp check_each_gear([distance], radius) do
    y = distance - 0.5 * radius
    {y, radius >= @minimum_radius_first_gear && y >= @minimum_radius_all_gears}
  end

  # The radius of any non-last gear is the dinstance between its peg and the previous peg minus the
  # radius of the next gear's radius.
  #
  # y = distance - z
  defp check_each_gear([distance | other], radius) do
    {next_radius, valid?} = check_each_gear(other, radius)
    this_radius = distance - next_radius

    {this_radius, valid? && this_radius > @minimum_radius_all_gears}
  end
end
