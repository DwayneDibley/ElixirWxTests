defmodule WinInfo do
  require Logger

  @moduledoc """
  A process wide table containing the window information
  """
  def new_table() do
    :ets.new(table_name(), [:set, :protected, :named_table])
  end

  def put_table(value) do
    :ets.insert_new(table_name(), value)
  end

  def get_by_name(name) do
    display_table()
    res = :ets.lookup(table_name(), name)

    {name, id, obj} =
      case length(res) do
        0 -> {nil, nil, nil}
        _ -> List.first(res)
      end

    {name, id, obj}
  end

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

  def display_rows([h | t]) do
    Logger.info("  #{inspect(h)}")
    display_rows(t)
  end

  def table_name() do
    String.to_atom("#{inspect(self())}")
  end
end
