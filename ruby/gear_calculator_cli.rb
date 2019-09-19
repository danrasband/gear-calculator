# frozen_string_literal: true

require_relative './gear_calculator.rb'

# The GearCalculatorCLI wraps the interface functionality for the program and
# validates user input.
class GearCalculatorCLI
  def self.run(args = [])
    new(args).run
  end

  def initialize(args = [])
    usage! if args.count.nonzero?
  end

  # Read and validate and delegate to the gear calculator.

  # Assumes input comes in one line at a team, each line containing a single
  # integer. The integer 0 indicates the end of pegs, and 0 is not included.
  # Additional error checking has been avoided for the sake of simplicity.
  def run
    pegs = read_input
    usage! if pegs.empty?

    numerator, denominator = GearCalculator.answer(pegs)
    puts "[#{numerator}, #{denominator}]"
  end

  private

  def read_input
    pegs = []

    while (peg = gets.chomp.to_i).nonzero?
      pegs << peg
    end

    pegs
  end

  def usage!
    STDERR.puts <<-EOD
Usage: ./gear_calculator

  After invoking the gear_calculator program, type the position of each peg,
  followed by [ENTER]. When you have entered all the peg positions, enter 0,
  then [ENTER].
EOD
    exit(1)
  end
end
