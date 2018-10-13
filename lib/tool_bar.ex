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

  # def commandButton(window, :command_button_clicked, :exit_btn, _senderObj) do
  #  Logger.debug("event from :exit_btn")
  #  :closeWindow
  # end

  # def windowClosed(window, eventType, senderId, _senderObj) do
  #  # showEvent(event, eventSource, windowData)
  #  IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
  #  Logger.info("TestWindow windowClosed(#{inspect(self())})")
  #  # closeWindow(window)
  #  :closeWindow
  # end
end