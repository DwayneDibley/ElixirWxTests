defmodule SizerSpacer do
  require Logger
  use WxDefines

  @moduledoc """
  A demo of a simple tool bar.
  """
  def run() do
    Logger.info("Spacer Test Starting")

    SizerSpacerWindow.createWindow(show: true)

    # We break out of the loop when the exit button is pressed.
    Logger.info("Spacer Test Exiting")
    {:ok, self()}
  end
end
