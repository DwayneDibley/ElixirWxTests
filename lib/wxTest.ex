defmodule WxTest do
  import WxFunctions
  require Logger
  use WxDefines

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
  def start(_a, _b) do
    System.put_env("WX_APP_TITLE", "ElixirWx Test")

    winInfo = TestWindow.createWindow(show: true)
    loop(winInfo)

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")
    {:ok, self()}
  end

  defp loop(winInfo) do
    event = getEvent(1)
    #Logger.info("Received event: #{inspect(event)}")

    case event do
      {:countdown_btn, _, _} ->
        input = getObjText(:time_input, winInfo)
        Logger.debug("Got #{inspect(input)} from :time_input")
        time = String.to_integer(input)
        Logger.debug("In to countdown")
        countDown(time, winInfo)

        {:msg_dlg_test, _, _} ->
          WxMessageDialogTest.run()
          loop(winInfo)

          {:menu_test, _, _} ->
              MenuTest.run()
              loop(winInfo)

          {:test, _, _} ->
                  TestCode.run()

      {:exit_btn, _, _} ->
        closeWindow(winInfo)

      :timeout ->
        loop(winInfo)

      _ ->
        Logger.error("Unexpected event #{inspect(event)} in main loop")
        loop(winInfo)
    end
  end

  defp countDown(0, winInfo) do
    putObjText(:output, "Zero", winInfo)
  end

  defp countDown(time, winInfo) do
    putObjText(:output, Integer.to_string(time), winInfo)

    :timer.sleep(1000)

    countDown(time - 1, winInfo)
  end

  def buttonPushed(event, eventSource, windowData) do
    showEvent(event, eventSource, windowData)
    # closeWindow(windowData)
  end

  def windowClosed(event, eventSource, windowData) do
    showEvent(event, eventSource, windowData)
    closeWindow(windowData)
  end

  def showEvent(event, eventSource, windowData) do
    {wData, xrefData} = windowData
    Logger.debug("====================================")
    Logger.debug("event = #{inspect(event)}")
    Logger.debug("eventSource = #{inspect(eventSource)}")
    Logger.debug("wData = #{inspect(wData)}")
    Logger.debug("xrefData = #{inspect(xrefData)}")
    Logger.debug("====================================")
  end
end
