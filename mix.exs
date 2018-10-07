defmodule WxTests.MixProject do
  use Mix.Project

  def project do
    [
      app: :wx_tests,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      # escript: escript(),
      deps: deps()
    ]
  end

  # Must be added.
  def escript do
    [main_module: Demo]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WxTest, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:elixirwx, git: "https://github.com/DwayneDibley/ElixirWx.git"},
      {:ex_doc, "~> 0.18"}
    ]
  end
end
