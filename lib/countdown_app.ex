defmodule CountdownApp do
  import WxFunctions
  require Logger

  @moduledoc """
  ```
  An example based on the countdown timer by "Doug Edmunds".
  """

  @doc """
  The main entry point.
  """
  def start() do
    System.put_env("WX_APP_TITLE", "Another Tutorial")

    winInfo = CountdownWindow.createWindow(show: true)
    loop(winInfo)
    IO.inspect("Exiting")
    {:ok, self()}
  end

  @doc """
  Once the window has been created, loop waiting for events.
  """
  defp loop(winInfo) do
    event = getEvent()
    Logger.debug("Received event: #{inspect(event)}")

    case event do
      {:countdown_btn, _, _} ->
        input = getObjText(:time_input, winInfo)
        Logger.debug("Got #{inspect(input)} from :time_input")
        time = String.to_integer(input)
        Logger.debug("In to countdown")
        countDown(time, winInfo)
        loop(winInfo)

      {:exit_btn, _, _} ->
        closeWindow(winInfo)
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
