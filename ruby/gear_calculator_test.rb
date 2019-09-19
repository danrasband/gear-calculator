#!/usr/bin/env ruby
# froze_string_literal: true

require 'test/unit'
require_relative './gear_calculator.rb'

# Test the GearCalculator class.
class GearCalculatorTest < Test::Unit::TestCase
  TEST_CASES = [
    {
      input: [4, 30, 50],
      output: [12, 1]
    },
    {
      input: [4, 8],
      output: [8, 3]
    },
    {
      input: [1, 504, 1224],
      output: [-1, -1]
    },
    {
      input: [100, 105, 115, 225, 300, 350],
      output: [-1, -1]
    },
    {
      input: [1, 15, 39, 55, 73, 89],
      output: [8, 3]
    },
    {
      input: [3, 40, 50],
      output: [-1, -1]
    },
    {
      input: [30, 40, 45],
      output: [-1, -1]
    },
    {
      input: [30, 50, 50],
      output: [-1, -1]
    }
  ].freeze

  def test_all
    TEST_CASES.each do |test_case|
      assert_equal(GearCalculator.answer(test_case[:input]), test_case[:output])
    end
  end
end
