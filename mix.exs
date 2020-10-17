defmodule KeyboardLayout.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :keyboard_layout,
      version: @version,
      elixir: "~> 1.10",
      deps: deps(),
      description: description(),
      dialyzer: dialyzer(),
      preferred_cli_env: preferred_cli_env(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false}
    ]
  end

  defp description do
    """
    Functions for using and defining keyboard layouts with keys and LEDs
    """
  end

  defp dialyzer do
    [
      plt_core_path: "_build/#{Mix.env()}",
      flags: [:unmatched_returns, :error_handling, :underspecs]
    ]
  end

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.json": :test,
      credo: :test
    ]
  end
end
