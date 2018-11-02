defmodule WxStyledTextCtrl do
  import WxUtilities
  import WinInfo

  require Logger

  def new(parent, attributes) do
    Logger.info("WxStyledTextCtrl.new(#{inspect(parent)}, #{inspect(attributes)})")
    new_id = :wx_misc.newId()

    defaults = [id: "_no_id_#{inspect(new_id)}", style: nil, size: nil]
    {id, options, restOpts} = WxUtilities.getOptions(attributes, defaults)

    Logger.debug("  :WxStyledTextCtrl.new(#{inspect(parent)}, #{inspect(options)}")

    win = :wxStyledTextCtrl.new(parent, options)
    put_table({id, new_id, win})

    {id, new_id, win}
  end
end
