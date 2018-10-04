defmodule WxTests do
  use Mix.Task
  @moduledoc """
  Documentation for WxTests.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WxTests.hello()
      :world

  """

  def main(a) do
    IO.inspect("Hello world 1")
  end

  def start(a,b) do
      System.put_env("WX_APP_TITLE", "DSL Tests")
      {:ok, self()}
      {_info, _xref} = CountdownApp.start()
    end

  def hello do
    IO.inspect("Hello world 3")
  end

  def run(_) do
    IO.inspect("Hello world 3")
  end

end
