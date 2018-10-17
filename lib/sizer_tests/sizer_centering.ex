defmodule SizerCentering do
  require Logger
  use WxDefines

  @moduledoc """

  """
  def run() do
    Logger.info("Centering Test Starting")

    SizerCenteringWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Centering Test Exiting")
    {:ok, self()}
  end
end
