defmodule MenuTest do
  require Logger
  use WxDefines

  @moduledoc """
  ```
  A demo of wxWindows menu's.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """

  def start(_a, _b) do
    run()
    {:ok, self()}
  end

  def run() do
    Logger.info("Menu test starting")

    MenuTestWindow.createWindow(show: true)
    # loop(winInfo)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Menu Test Exiting")
    {:ok, self()}
  end

  def commandButton(_window, _eventType, senderId, _senderObj) do
    Logger.debug("unexpected event from #{inspect(senderId)}")
  end

  def commandMenu(_window, _eventType, senderId, _senderObj) do
    Logger.debug("unexpected event from #{inspect(senderId)}")
  end

  def windowClosed(window, eventType, senderId, _senderObj) do
    # showEvent(event, eventSource, windowData)
    IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    Logger.info("TestWindow windowClosed(#{inspect(self())})")
    # closeWindow(window)

    # :wx_object.stop(window)
  end
end
