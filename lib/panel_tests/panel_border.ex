defmodule PanelBorders do
  # import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Panel Border Test Starting")

    PanelBorderWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Panel Border Test Exiting")
    {:ok, self()}
  end

  def commandButton(PanelBorderWindow, :command_menu_selected, button, _senderObj) do
    Logger.debug(":command_menu_selected = #{inspect(button)}")
    # WxMessageDialogTest.run()
    WxStatusBar.setText("Tool Bar Button clicked: #{inspect(button)}")
  end
end
