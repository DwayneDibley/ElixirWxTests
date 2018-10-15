defmodule Test do
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

  @doc """
  Am menu item was selected
  """
  def doMenuEvent(window, eventType, senderId, senderObj) do
    Logger.info(
      "menu event: #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)}, #{
        inspect(senderObj)
      }"
    )

    case senderId do
      :simple_frame -> spawn_link(fn -> SimpleFrame.run() end)
      :tool_bar -> spawn_link(fn -> ToolBar.run() end)
      :box_sizer -> spawn_link(fn -> BoxSizer.run() end)
      :static_box_sizer -> spawn_link(fn -> StaticBoxSizer.run() end)
    end
  end

  def commandMenu(window, eventType, senderId, senderObj) do
    Logger.info(
      "menu event xxx: #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)}, #{
        inspect(senderObj)
      }"
    )
  end

  def commandButton(TestWindow, :command_button_clicked, :msg_dlg_test, _senderObj) do
    Logger.debug("event from :msg_dlg_test")
    WxMessageDialogTest.run()
  end

  def commandButton(TestWindow, :command_button_clicked, :menu_test, _senderObj) do
    Logger.debug("Starting Menu test")

    spawn_link(fn ->
      MenuTest.run()
    end)
  end

  def commandButton(TestWindow, :command_button_clicked, :test, _senderObj) do
    Logger.debug("event from :msg_dlg_test")
  end

  def commandButton(TestWindow, :command_button_clicked, :exit_btn, _senderObj) do
    Logger.debug("event from :exit_btn")
    :closeWindow
  end

  def commandButton(_window, _eventType, senderId, _senderObj) do
    Logger.debug("unexpected event from #{inspect(senderId)}")
  end

  def timeout(window, _eventType, _senderId, _senderObj) do
    Logger.debug("Timeout event from #{inspect(window)}")
    # Timeout must return an integer, or nil for the same timeout gain.
    # If an integer is returned it sets a new timeout value
    5000
  end

  def windowClosed(window, eventType, senderId, _senderObj) do
    IO.inspect("windowClosed = #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)})")
    Logger.info("TestWindow windowClosed(#{inspect(self())})")
    closeWindow(window)
  end
end
