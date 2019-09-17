defmodule GearCalculator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gear_calculator,
      version: "0.0.1",
      elixir: "~> 1.8",
      elixirc_paths: ["lib"],
      deps: deps(),
      escript: escript()
    ]
  end

  defp deps do
    [{:credo, "~> 1.0.1", only: [:dev, :test], runtime: false}]
  end

  defp escript do
    [main_module: GearCalculator.CLI]
  end
end
