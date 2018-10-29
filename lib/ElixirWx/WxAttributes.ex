defmodule Attributes do
  require Logger

  def setAttr(objName, attr, val) do
    {object, type} = getObjectInfo(objName)

    case attr do
      :text -> setText(object, type, val)
    end
  end

  def getAttr(objName, attr) do
    {object, type} = getObjectInfo(objName)

    case attr do
      :text -> getText(object, type)
    end
  end

  defp setText(_object, type, _text) do
    case type do
      _ -> Logger.warn("setText(): #{inspect(type)} has no text attribute")
    end
  end

  defp getText(_object, type) do
    case type do
      _ -> Logger.warn("getText(): #{inspect(type)} has no text attribute")
    end
  end

  defp getObjectInfo(objName) do
    {_, _, object} = WinInfo.get_by_name(objName)
    {_, _, type, _} = object
    {object, type}
  end
end
