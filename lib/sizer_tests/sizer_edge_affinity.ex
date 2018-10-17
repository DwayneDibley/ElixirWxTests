defmodule EdgeAffinitySizer do
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Edge Affinity sizer Test Starting")

    EdgeAffinitySizerWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Edge Affinity Sizer Test Exiting")
    {:ok, self()}
  end
end
