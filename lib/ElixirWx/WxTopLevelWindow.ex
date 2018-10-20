defmodule WxTopLevelWindow do
  require Logger
  use WxDefines

  def setIcon(iconFile) do
    case iconFile do
      nil -> :ok
      iconFile -> setWindowIcon(iconFile)
    end
  end

  defp setWindowIcon(iconFile) do
    {_, _, frame} = WinInfo.get_by_name(:__main_frame__)

    {:ok, cwd} = File.cwd()
    file = Path.join(cwd, iconFile)

    options = [type: @wxBITMAP_TYPE_ICO]
    Logger.info(":wxIcon.new(#{inspect(file)}, #{inspect(options)})")
    icon = :wxIcon.new(file, options)

    Logger.info(":wxTopLevelWindow.setIcon(#{inspect(frame)}, #{inspect(icon)})")
    :wxTopLevelWindow.setIcon(frame, icon)
  end
end
