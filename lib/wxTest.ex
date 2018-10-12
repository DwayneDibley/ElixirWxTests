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



    try do
      _window = TestWindow.createWindow(show: true)
    rescue
      e in RuntimeError -> Logger.error("Exiting main loop: #{inspect(e)}")
    end

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")
    {:ok, self()}
  end

  defp loop(window) do
    event = getEvent(10)
    Logger.debug("Received event: #{inspect(event)}")

    case event do
      {WindowExit, TestWindow} ->
        Logger.info("event {WindowExit, TestWindow}")
        :ok

      {:exit_btn, _, _} ->
        closeWindow(TestWindow)

      :timeout ->
        #:wx_object.stop(window, :xxxx, 1)
        #:wx.destroy()
        #send(self, {WindowExit, TestWindow})
        loop(window)

      _ ->
        Logger.error("Unexpected event #{inspect(event)} in main loop")
        loop(window)
    end
  end

  @doc """
  Event callbacks, remember these are called from the window service loop,
  and so any long running processing here will freeze the window.
  """
  # callback(window, eventType, senderId, senderObj)
  def commandButton(TestWindow, :command_button_clicked, :exit_btn, _senderObj) do
    Logger.debug("event from :exit_btn")
    closeWindow(TestWindow)
  end

  def commandButton(TestWindow, :command_button_clicked, :msg_dlg_test, _senderObj) do
    Logger.debug("event from :msg_dlg_test")
    WxMessageDialogTest.run()
  end

  def commandButton(TestWindow, :command_button_clicked, :menu_test, _senderObj) do
    Logger.debug("event from :msg_dlg_test")
    spawn_link(fn ->
        MenuTest.run()
        end)
  end

  def commandButton(TestWindow, :command_button_clicked, :test, _senderObj) do
    Logger.debug("event from :msg_dlg_test")
  end

  def commandButton(_window, _eventType, senderId, _senderObj) do
    Logger.debug("unexpected event from #{inspect(senderId)}")
  end

  def windowClosed(window, eventType, senderId, _senderObj) do
    #showEvent(event, eventSource, windowData)
    IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    Logger.info("TestWindow windowClosed(#{inspect(self())})")
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
