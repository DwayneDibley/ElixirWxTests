defmodule ToolBar do
  import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Tool Bar Test Starting")

    ToolBarWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Tool Bar Test Exiting")
    {:ok, self()}
  end

  def commandButton(ToolBarWindow,  :command_menu_selected, button, senderObj) do
    Logger.debug(":command_menu_selected = #{inspect(button)}")
    #WxMessageDialogTest.run()
    WxStatusBar.setText("Tool Bar Button clicked: #{inspect(button)}")
  end
  #def commandButton(ToolBarWindow, what, button, senderObj) do
  #  Logger.debug("event2: #{inspect(what)}, #{inspect(button)}, #{inspect(senderObj)}")
  #  #WxMessageDialogTest.run()
  #end

end
