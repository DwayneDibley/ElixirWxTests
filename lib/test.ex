defmodule Test do
  import WxWinObj.API
  require Logger
  use WxDefines

  # import WinInfo

  @moduledoc """
  A demo of the WxWindows DSL for creating GUIs.

  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """

  def main(_args) do
    start(1, 2)
  end

  def start(_a, _b) do
    # :observer.start()
    System.put_env("WX_APP_TITLE", "ElixirWx Test")
    Logger.info("start")

    newWindow(TestWindow, TestHandler, name: TestWindow, show: true)
    waitForWindowClose(TestWindow)

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")
    {:ok, self()}
  end


end
