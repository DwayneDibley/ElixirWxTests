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

    #res  = __ENV__.module
    Logger.error("#{inspect(__ENV__.module)}")

    window = TestWindow.createWindow(show: true)

    try do
      loop(window)
    rescue
      e in RuntimeError -> Logger.error("Exiting main loop: #{inspect(e)}")
    end

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")
    {:ok, self()}
  end

  defp loop(window) do
    event = getEvent(10)
    Logger.info("Received event: #{inspect(event)}")

    Logger.info("is null: #{inspect(window)}, #{inspect(:wx.is_null(window))}")

    case event do
      {:msg_dlg_test, _, _} ->
          WxMessageDialogTest.run()
          loop(window)

      {:menu_test, _, _} ->
              MenuTest.run()
              loop(window)

      {:test, _, _} ->
                  TestCode.run()

      {:exit_btn, _, _} ->
        closeWindow(TestWindow)

      :timeout ->
        #:wx_object.stop(window, :xxxx, 1)
        :wx.destroy()
        loop(window)

      _ ->
        Logger.error("Unexpected event #{inspect(event)} in main loop")
        loop(window)
    end
  end

#  defp countDown(0, winInfo) do
#    putObjText(:output, "Zero", winInfo)
#  end

#  defp countDown(time, winInfo) do
#    putObjText(:output, Integer.to_string(time), winInfo)
#
#    :timer.sleep(1000)
#
#    countDown(time - 1, winInfo)
#  end

  # callback(window, eventType, senderId, senderObj)
  def commandButton(TestWindow, :command_button_clicked, :exit_btn, senderObj) do
    Logger.debug("event from :exit_btn")
    closeWindow(TestWindow)
    #IO.inspect("Exit Buttons = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    #Logger.debug("commandButton(#{inspect(event)}, #{inspect(eventSource)}, #{inspect(windowData)})")
  end

  def commandButton(TestWindow, :command_button_clicked, :msg_dlg_test, senderObj) do
    Logger.debug("event from :msg_dlg_test")
    WxMessageDialogTest.run()
  end

  def commandButton(TestWindow, :command_button_clicked, :test, senderObj) do
    Logger.debug("event from :msg_dlg_test")
    #IO.inspect("Exit Buttons = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    #Logger.debug("commandButton(#{inspect(event)}, #{inspect(eventSource)}, #{inspect(windowData)})")
  end

  def commandButton(window, eventType, senderId, senderObj) do
    Logger.debug("unexpected event from #{inspect(senderId)}")
    #Logger.debug("commandButton(#{inspect(event)}, #{inspect(eventSource)}, #{inspect(windowData)})")
  end

  #def buttonPushed(event, eventSource, windowData) do
  #  showEvent(event, eventSource, windowData)
  #  # closeWindow(windowData)
  #end

  def windowClosed(window, eventType, senderId, senderObj) do
    #showEvent(event, eventSource, windowData)
    IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    closeWindow(window)

    #:wx_object.stop(window)
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
