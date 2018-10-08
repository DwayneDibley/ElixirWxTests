defmodule Elixirwx.MixProject do
  use Mix.Project

  def project do
    [ app: :elixirwx,
      version: "0.1.0",
      #deps: deps(),
      package: package(),
      description: "wxWindows interface for Elixir" ]
  end

  # Configuration for the OTP application
  #def application do
  #  [ applications: [:crypto, :ssl] ]
  #end

  #defp deps do
  #  [ { :ex_doc, "~> 0.18", only: [:dev] } ]
  #end

  defp package do
    [ maintainers: ["rwe"],
      licenses: ["WTFPL"],
      links: %{"GitHub" => "https://github.com/DwayneDibley/ElixirWx.git"} ]
  end
end
