defmodule ElixirwxTest do
  use ExUnit.Case
  doctest Elixirwx

  test "greets the world" do
    assert Elixirwx.hello() == :world
  end
end
