defmodule WinInfo do
  require Logger

  @moduledoc """
  A process wide table containing the window information
  """
  def new_table() do
    try do
      :ets.new(table_name(), [:set, :protected, :named_table])
    rescue
      _ ->
        Logger.warn("Attempt to create #{inspect(table_name())} failed: Table exists. ")
    end
  end

  def put_table(value) do
    :ets.insert_new(table_name(), value)
  end

  @doc """
  Given am atom, get the info for the object.
  """
  def get_by_name(name) do
    # display_table()
    res = :ets.lookup(table_name(), name)

    {name, id, obj} =
      case length(res) do
        0 -> {nil, nil, nil}
        _ -> List.first(res)
      end

    {name, id, obj}
  end

  @doc """
  Given a numeric ID, get the info for the object.
  """
  def get_by_id(id) do
    res = :ets.match_object(table_name(), {:_, id, :_})

    {name, id, obj} =
      case length(res) do
        0 -> {nil, nil, nil}
        _ -> List.first(res)
      end

    {name, id, obj}
  end

  def get_object_name(id) do
    {name, _id, _obj} = get_by_id(id)
    name
  end

  def get_events() do
    res = :ets.lookup(table_name(), :__events__)

    events =
      case length(res) do
        0 ->
          %{}

        _ ->
          {_, events} = List.first(res)
          events
      end

    events
  end

  def put_event(event_type, info) do
    res = :ets.lookup(table_name(), :__events__)

    events =
      case length(res) do
        0 ->
          %{}

        _ ->
          {_, events} = List.first(res)
          events
      end

    events = Map.put(events, event_type, info)
    :ets.insert(table_name(), {:__events__, events})
  end

  def display_table() do
    table = String.to_atom("#{inspect(self())}")
    all = :ets.match(table_name(), :"$1")
    Logger.info("Table: #{inspect(table)}")
    display_rows(all)
  end

  def display_rows([]) do
    :ok
  end

  def display_rows([[h] | t]) do
    Logger.info("  #{inspect(h)}")
    display_rows(t)
  end

  def table_name() do
    String.to_atom("#{inspect(self())}")
  end

  @doc """
    FIFO implemented using ETS storage.
  """
  def stack_push(value) do
    stack = get_stack()

    new_stack =
      case stack do
        [] ->
          [value]

        _ ->
          [value | stack]
      end

    # Logger.info("insert = #{inspect(new_stack)}")
    :ets.insert(table_name(), {:__stack__, new_stack})
  end

  def stack_tos() do
    stack = get_stack()
    # Logger.info("get tos = #{inspect(stack)}")

    tos =
      case stack do
        nil ->
          nil

        [tos | _rest] ->
          tos

        [] ->
          # Logger.info("get tos []")
          nil
      end

    tos
  end

  def stack_pop() do
    stack = get_stack()

    {tos, rest} =
      case stack do
        nil -> {nil, []}
        [] -> {nil, []}
        [tos | rest] -> {tos, rest}
      end

    :ets.insert(table_name(), {:__stack__, rest})
    tos
  end

  defp get_stack() do
    res = :ets.lookup(table_name(), :__stack__)

    # res =
    case res do
      [] -> []
      _ -> res[:__stack__]
    end
  end
end
