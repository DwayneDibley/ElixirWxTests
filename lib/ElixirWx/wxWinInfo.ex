defmodule WinInfo do

  require Logger

  def put_table(table, value) do
    Logger.info(":ets.insert_new(#{inspect(table)}, #{inspect(value)})")
    :ets.insert_new(table, value)
  end

  def get_by_name(table, name) do
    Logger.info(":ets.lookup(#{inspect(table)}, #{inspect(name)}) xxxx")
    res = :ets.lookup(table, name)
    {name, id, obj} = case length(res) do
      0 -> {nil, nil, nil}
      _ -> List.first(res)
    end

  end

  def get_by_id(table, id) do
    Logger.info(":ets.match(#{inspect(table)}, {:\"$1\" #{inspect(id)}})")
    res = :ets.match_object(table, {:"_", id, :"_"})
    {name, id, obj} = case length(res) do
      0 -> {nil, nil, nil}
      _ -> List.first(res)
    end
  end

  def display_table(table) do
    all = :ets.match(table, :"$1")
    Logger.info("Table: #{inspect(table)}")
    display_rows(all)
  end

  def display_rows([]) do
    :ok
  end

  def display_rows([h|t]) do
    Logger.info("  #{inspect(h)}")
    display_rows(t)
  end
end
