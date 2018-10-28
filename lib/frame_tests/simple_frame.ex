defmodule SimpleFrame do
  # import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple frame.
  """
  def run() do
    Logger.info("Simple Frame Test Starting")

    # pid =
    #  Process.spawn(CodeWindow, :run, ["lib/frame_tests/simple_frame_window.ex", self()], [
    #    :monitor
    #  ])

    # Logger.info("ewr = #{inspect(pid)}")

    # Process.monitor(pid)
    SimpleFrameWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Simple Frame Test Exiting")
    {:ok, self()}
  end
end
