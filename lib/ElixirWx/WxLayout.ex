defmodule WxLayout do
  require Logger
  import Bitwise

  def getLayoutAttributes(attributes) do
    defaults = [
      id: nil,
      proportion: nil,
      border_width: nil,
      border_flags: nil,
      align: nil,
      width: nil,
      height: nil
    ]

    {id, options, rest} = WxUtilities.getOptions(attributes, defaults)
    Logger.info("layout = #{inspect({id, options, rest})}")

    flags = addKeyToListAs(options, :proportion, :proportion, [])
    flags = addKeyToListAs(options, :border_width, :border, flags)
    border = getFlag(options, :border_flags, 0)
    align = getFlag(options, :align, 0)
    flags = [{:flag, border ||| align} | flags]

    height = getFlag(options, :height, nil)
    width = getFlag(options, :width, nil)

    {id, {width, height}, flags}
  end

  def addKeyToListAs(opts, key, newKey, list) do
    new_list =
      case List.keyfind(opts, key, 0) do
        nil -> list
        {_key, val} -> [{newKey, val} | list]
      end

    new_list
  end

  def getFlag(opts, key, default \\ nil) do
    new_val =
      case List.keyfind(opts, key, 0) do
        nil -> default
        {_key, val} -> val
      end

    new_val
  end

  def getLayout(name) do
    Logger.info("getLayout(#{inspect(name)})")
    {name, size, layout} = WinInfo.get_by_name(name)
    Logger.info("getLayout(#{inspect(name)}) => #{inspect({name, size, layout})}")
    layout
  end
end
