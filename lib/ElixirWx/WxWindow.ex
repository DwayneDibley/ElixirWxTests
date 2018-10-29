defmodule WxWindow do
  require Logger

  import WxUtilities
  import WinInfo

  @doc """
  Get the window options and create a new window.
  """
  def new(parent, attributes) do
    new_id = :wx_misc.newId()

    defaults = [id: "_no_id_#{inspect(new_id)}", style: nil, size: nil]
    {id, options, _restOpts} = getOptions(attributes, defaults)

    Logger.debug("  :wxWindow.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)}")
    win = :wxWindow.new(parent, new_id, options)

    put_table({id, new_id, win})

    {id, new_id, win}
  end

  # def show(how \\ true) do
  #   {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
  #   :wxFrame.show(frame)
  # end
end
