defmodule SizerStretchable do
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Stretchable sizer Test Starting")

    SizerStretchableWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Stretchable Sizer Test Exiting")
    {:ok, self()}
  end

  def commandButton(BoxSizerWindow, :command_menu_selected, button, _senderObj) do
    Logger.debug(":command_menu_selected = #{inspect(button)}")
    # WxMessageDialogTest.run()
    WxStatusBar.setText("Tool Bar Button clicked: #{inspect(button)}")
  end
end
