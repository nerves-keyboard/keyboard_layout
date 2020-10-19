defmodule KeyboardLayout.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/nerves-keybaord/keyboard_layout"

  def project do
    [
      app: :keyboard_layout,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: preferred_cli_env(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: dialyzer(),
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
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

  defp dialyzer do
    [
      plt_core_path: "_build/#{Mix.env()}"
    ]
  end

  defp description do
    """
    Functions for using and defining keyboard layouts with keys and LEDs
    """
  end

  defp package do
    [
      files: ["lib", ".formatter.exs", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Chris Dosé <chris.dose@gmail.com>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Readme" => "#{@source_url}/blob/v#{@version}/README.md"
      }
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: [
        "README.md": [title: "README"],
        "LICENSE.md": [title: "LICENSE"]
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false}
    ]
  end
end
