defmodule WindowServer do
  use GenServer

  def start_link(init_value \\ 0, opts \\ []) do
    GenServer.start_link(__MODULE__, init_value, opts)
  end
  ## client apis
  def get(c) do
    GenServer.call(c, {:get})
  end
  def increment(c, delta \\ 1) do
    GenServer.cast(c, {:increment, delta})
  end
  def increment_and_get(c, delta \\ 1) do
    GenServer.call(c, {:increment_and_get, delta})
  end

  ##GenServer callbacks
  def init(v) do
    {:ok, v}
  end

  def handle_call({:get}, _from, v) do
    {:reply, v, v}
  end

  def handle_call({:increment_and_get, detal}, _from, v) do
    new_v = v + detal
    {:reply, new_v, new_v}
  end

  def handle_cast({:increment, delta}, v) do
    {:noreply, delta + v}
  end

end
