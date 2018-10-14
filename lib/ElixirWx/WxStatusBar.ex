defmodule WxStatusBar do

  def setText(text) when is_binary(text) do
   {_, _, sb} = WinInfo.get_by_name(:status_bar)
   :wxStatusBar.setStatusText(sb, text)
 end

  def setText(sb, text) when is_binary(text), do: :wxStatusBar.setStatusText(sb, text)

  def setText(sb, text) when is_list(text) do
    :wxStatusBar.setFieldsCount(sb, length(text))
    setTextList(sb, text, 0)
  end

  def setTextList(_, [], _), do: :ok

  def setTextList(sb, [h | t], n) do
    :wxStatusBar.setStatusText(sb, h, [{:number, n}])
    setTextList(sb, t, n + 1)
  end


end
