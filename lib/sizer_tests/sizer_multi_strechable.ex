defmodule SizerMultiStretchable do
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Multiple Stretchable sizers Test Starting")

    SizerMultiStretchableWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Multiple Stretchable sizers Test Exiting")
    {:ok, self()}
  end
end
