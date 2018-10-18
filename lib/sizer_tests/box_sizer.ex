defmodule BoxSizer do
  # import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  Box sizer test.
  """
  def run() do
    Logger.info("Box_sizer Test Starting")

    BoxSizerWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Box Sizer Test Exiting")
    {:ok, self()}
  end

  def commandButton(BoxSizerWindow, :command_menu_selected, button, _senderObj) do
    Logger.debug(":command_menu_selected = #{inspect(button)}")
    # WxMessageDialogTest.run()
    WxStatusBar.setText("Tool Bar Button clicked: #{inspect(button)}")
  end
end
