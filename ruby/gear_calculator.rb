# frozen_string_literal: true

# Runs calculations on a set of pegs to determine the radius of the first gear
# that will make the RPMs of the last gear double that of the first.
class GearCalculator
  # The minimum radius of the first gear is 1.
  MINIMUM_RADIUS_FIRST_GEAR = 1.0

  # The minimum radius of any radius is 0.5. This assumption is made based on
  # the fact that the first gear's radius must be twice the size of the last
  # gear's radius, and the first radius can't be any smaller than 1. That
  # indicates that the last gear's radius could be 0.5 units, and if it can be
  # 0.5 units, then why not the other gears?
  MINIMUM_RADIUS_ALL_GEARS = 0.5

  # Convenience function that creates a new instance of GearCalculator and
  # invokes GearCalculator#answer.
  def self.answer(pegs)
    new(pegs).answer
  end

  def initialize(pegs)
    @pegs = pegs
    @distances = distances_between_pegs.freeze
  end
  attr_reader :pegs

  # Determine the fraction representation of the size of the first gear in a
  # series of gears along a support beam that will make the last gear rotate at
  # double the RPM of the first gear.
  def answer
    constant, coefficient = coefficient_and_constant(@distances.dup)

    validate_and_simplify(constant, (1 - coefficient))
  end

  private

  def distances_between_pegs
    distances_and_peg =
      pegs.each_with_object([[], nil]) do |peg, data|
        data[0] << peg - data[1] if data[1]
        data[1] = peg
      end

    distances_and_peg[0]
  end

  # Recursively calculates the coefficient of each gear radius and the constant
  # that goes along with it. This helps solve systems of equations like the
  # following:
  #
  #   x_1 + x_2 = y_1
  #   x_2 + x_3 = y_2
  #   ...
  #   x_n + 0.5 * x_1 = y_n
  #
  # Returns an array including a constant and a radius coefficient.
  def coefficient_and_constant(distances)
    distance = distances.shift
    return [distance, -0.5] if distances.empty?

    constant, coefficient = coefficient_and_constant(distances)
    [distance - constant, -coefficient]
  end

  # Validates the calculated gear ratio and then simplifies the fraction.
  def validate_and_simplify(numerator, denominator)
    return [-1, -1] unless valid?(numerator, denominator)

    simplify(numerator, denominator).map(&:to_i)
  end

  # Validates that the calculated gear ratio doesn't cause any gears down the
  # line to be too small or negative.
  def valid?(numerator, denominator)
    return unless numerator && denominator

    first_gear_radius = numerator / denominator
    _, valid = check_each_gear(@distances.dup, first_gear_radius)

    valid
  end

  # Recursively simplifies the radius fraction.
  def simplify(numerator, denominator)
    if (numerator % 1).nonzero? || (denominator % 1).nonzero?
      # Double the numerator and denominator to get them into integer-shape,
      # since the denominator will always be 0.5 or 1.5.
      return simplify(numerator * 2, denominator * 2)
    end

    return [numerator, denominator] if denominator == 1

    divisor = numerator.to_i.gcd(denominator.to_i)
    return [numerator, denominator] if divisor == 1

    simplify((numerator / divisor), (denominator / divisor))
  end

  # Recursively checks each gear.
  def check_each_gear(distances, radius)
    distance = distances.shift

    if distances.empty?
      penultimate_radius = distance - 0.5 * radius
      return [
        penultimate_radius,
        penultimate_radius >= MINIMUM_RADIUS_ALL_GEARS &&
        radius >= MINIMUM_RADIUS_FIRST_GEAR
      ]
    end

    next_radius, valid = check_each_gear(distances, radius)
    this_radius = distance - next_radius

    [this_radius, valid && this_radius >= MINIMUM_RADIUS_ALL_GEARS]
  end
end
