defmodule ButtonTest do
  require Logger
  use WxDefines

  # import WinInfo

  @moduledoc """
  ```
  A demo of the WxWindows DSL for creating GUIs.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """
  def run() do
    Logger.info("Button Test Starting")

    ButtonTestWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Vertical Sizer Test Exiting")
    {:ok, self()}
  end
end
