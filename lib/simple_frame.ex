defmodule SimpleFrame do
  import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  ```
  A demo of a simple frame.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """

  def run() do
    Logger.info("Menu test starting")

    SimpleFrameWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Simple Frame Exiting")
    {:ok, self()}
  end

  def commandButton(window, :command_button_clicked, :exit_btn, _senderObj) do
    Logger.debug("event from :exit_btn")
    # closeWindow(TestWindow)
    :closeWindow
  end

  def windowClosed(window, eventType, senderId, _senderObj) do
    # showEvent(event, eventSource, windowData)
    IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    Logger.info("TestWindow windowClosed(#{inspect(self())})")
    # closeWindow(window)
    :closeWindow
  end
end
