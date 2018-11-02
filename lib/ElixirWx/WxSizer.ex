defmodule WxSizer do
  require Logger

  def addToSizer(obj, sizer, options) do
    defaults = [layout: []]
    {_, [layout: options], _} = WxUtilities.getOptions(options, defaults)
    Logger.debug("  :addToSizer(#{inspect(sizer)}, #{inspect(obj)}, #{inspect(options)})")

    case sizer do
      {:wx_ref, _, :wxBoxSizer, _} ->
        Logger.debug("  :wxSizer.add(#{inspect(sizer)}, #{inspect(obj)}, #{inspect(options)})")

        :wxSizer.add(sizer, obj, options)

      {:wx_ref, _, :wxStaticBoxSizer, _} ->
        Logger.error("  Not implemented")

      nil ->
        Logger.error("  Not implemented")
    end
  end

  def add(obj, sizer, options) do
    defaults = [layout: []]
    {_, [layout: layoutOptions], _} = WxUtilities.getOptions(options, defaults)

    defaults = [proportion: nil, flag: nil, border: nil]
    {_, options, _} = WxUtilities.getOptions(layoutOptions, defaults)
    Logger.debug("  :addToSizer(#{inspect(sizer)}, #{inspect(obj)}, #{inspect(options)})")

    case sizer do
      {:wx_ref, _, :wxBoxSizer, _} ->
        Logger.debug(
          ":wxSizer.add(#{inspect(sizer)}, #{inspect(obj)}, #{inspect(layoutOptions)})"
        )

        :wxSizer.add(sizer, obj, layoutOptions)

      {:wx_ref, _, :wxStaticBoxSizer, _} ->
        Logger.error("  Not implemented")

      nil ->
        Logger.error("  Not implemented")
    end
  end
end
