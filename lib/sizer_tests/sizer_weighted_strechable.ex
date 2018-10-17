defmodule SizerWeightedStretchable do
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Weighted Stretchable sizers Test Starting")

    SizerWeightedStretchableWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Weighted Stretchable sizers Test Exiting")
    {:ok, self()}
  end
end
