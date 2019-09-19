# Gear Calculator

Calculate the radius of the first gear in a system of gears.

## Implementations

### Elixir

The main implementation is written in Elixir, and can be found in the `elixir` folder.

To run the elixir implementation, change into the `elixir` folder and run the
following:

```bash
# Get dependencies (credo is the only one being used, just for its code
# checking capabilities).
mix deps.get

# Compile the CLI script
mix escript.build

# Run the CLI, followed by the peg locations, one per line, then a 0 to
# indicate you are done.
./gear_calculator
```

Test cases can be run with the following command:

```bash
mix test
```

### Ruby

The Ruby implementation was written second, and mimics the Elixir implementation very closely.

To run the Ruby implementation of the gear calculator, change into the `ruby` folder and use the following command, followed by the peg locations, one per line, then a 0 to indicate you are done:

```bash
ruby gear_calculator

# OR on Mac or Linux:

./gear_calculator
```

Tests can be run with the following command:

```bash
ruby gear_calculator_test.rb

# OR on Mac or Linux:

./gear_calculator_test.rb
```

## The Algorithm

The algorithm behind calculating the radii of gears in a system as outlined in the problem statement involves solving a simplified system of linear equations. The first gear affects the size of the second gear, the third the fourth, and so on. Because of this deterministic relationship, the same is true when going backwards. This lends itself nicely to a set of recursive functions.

To calculate the radius of the first gear, we need to set up the problem into a system of radii and distances between pegs. We represent this system of equations below, with `x` representing a radius and y representing the distance between pegs:

![LaTeX Version](https://latex.codecogs.com/svg.latex?%5Cbegin%7Balign*%7D%0Ax_0%20%2B%20x_1%20%3D%20y_0%5C%5C%0Ax_1%20%2B%20x_2%20%3D%20y_1%5C%5C%0A...%5C%5C%0Ax_n%20%2B%200.5%20*%20x_0%20%3D%20y_n%0A%5Cend%7Balign*%7D)

<!--
x_0 + x_1 = y_0
x_1 + x_2 = y_1
...
x_n + 0.5 * x_0 = y_n
-->

Since we know the values of ![y_0, y_1, ..., y_n](https://latex.codecogs.com/svg.latex?y_0%2C%20y_1%2C%20...%2C%20y_n), we can use simple substitution to carry the coefficient up the chain and calculate the constant from distances.
