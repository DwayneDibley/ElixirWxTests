defmodule Countdown.CLI do
  @moduledoc """
  Documentation for Countdown.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Countdown.hello()
      :world

  """
  def main(args) do
    IO.puts("Hello!")
    System.put_env("WX_APP_TITLE", "DSL Tests")
    {_info, _xref} = CountdownApp.start()
  end
end
