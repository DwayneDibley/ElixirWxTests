defmodule Test do
  import WxFunctions
  require Logger
  use WxDefines

  # import WinInfo

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

  def main(_args) do
    start(1, 2)
    # System.put_env("WX_APP_TITLE", "ElixirWx Test")
    #
    # Logger.info("main")
    # {:ok, window} = WxWindowObject.start_link(TestWindow, TestHandler, true)
    # WxWindowObject.show(window)
    #
    # # try do
    # #  _window = TestWindow.createWindow(show: true)
    # # rescue
    # #  e in RuntimeError -> Logger.error("Exiting main loop: #{inspect(e)}")
    # # end
    #
    # Logger.info("#{inspect(__ENV__.file)}")
    #
    # # We break out of the loop when the exit button is pressed.
    # Logger.info("ElixirWx Test Exiting")
    # {:ok, self()}
  end

  def start(_a, _b) do
    :observer.start()
    System.put_env("WX_APP_TITLE", "ElixirWx Test")
    Logger.info("start")

    # WxWindowObject.start_link(<window module>, <event handler module>, show \\ true)
    # case WxWindowObject.start_link(TestWindow, TestHandler, false) do
    testWindow =
      case newWindow(:test_window, {TestWindow, TestHandler}, false) do
        {:ok, window} ->
          window

        {:error, reason} ->
          Logger.error("Cannot create window> #{inspect(reason)}")
          :err
      end

    WxWindowObject.show(testWindow, true)

    # Wait for the window to exit...
    waitForWindow()

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")
    {:ok, self()}
  end

  def waitForWindow() do
    receive do
      msg ->
        Logger.info("Received: #{inspect(msg)}")
        waitForWindow()
    after
      1000 ->
        Logger.info("Receive loop")
        waitForWindow()
    end
  end

  @doc """
  Am menu item was selected
  """
  def doMenuEvent(_window, _eventType, senderId, _senderObj) do
    #    Logger.info(
    #      "menu event: #{inspect(window)}, #{inspect(eventType)}, #{inspect(senderId)}, #{
    #        inspect(senderObj)
    #      }"
    #    )

    case senderId do
      :simple_frame ->
        spawn_link(fn -> SimpleFrame.run() end)

      :tool_bar ->
        spawn_link(fn -> ToolBar.run() end)

      :box_sizer ->
        spawn_link(fn -> BoxSizer.run() end)

      :static_box_sizer ->
        spawn_link(fn -> StaticBoxSizer.run() end)

      :panel_borders ->
        spawn_link(fn -> PanelBorders.run() end)

      :test_code ->
        spawn_link(fn -> TestCode.run() end)

      :vertical_sizer ->
        spawn_link(fn -> VerticalSizer.run() end)

      :horizontal_sizer ->
        spawn_link(fn -> HorizontalSizer.run() end)

      :stretchable_sizer ->
        spawn_link(fn -> SizerStretchable.run() end)

      :stretchable_sizers ->
        spawn_link(fn -> SizerMultiStretchable.run() end)

      :weighted_sizers ->
        spawn_link(fn -> SizerWeightedStretchable.run() end)

      :edge_affinity ->
        spawn_link(fn -> EdgeAffinitySizer.run() end)

      :spacer ->
        spawn_link(fn -> SizerSpacer.run() end)

      :center ->
        spawn_link(fn -> SizerCentering.run() end)

      :dialogs ->
        spawn_link(fn -> DialogTest.run() end)

      :button ->
        spawn_link(fn -> ButtonTest.run() end)

      :code_window ->
        spawn_link(fn -> CodeWindow.run(__ENV__.file) end)

      :exit ->
        :closeWindow

      _ ->
        Logger.error("Unhandled menu click #{inspect(senderId)}")
    end
  end

  def commandMenu(window, eventType, _senderId, _senderObj) do
    Logger.info("menu event: #{inspect(window)}, #{inspect(eventType)}}")
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
