defmodule MenuTest do
  import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  ```
  A demo of wxWindows menu's.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """

  def start(_a, _b) do
    run()
  end

  def run() do
    winInfo = MenuTestWindow.createWindow(show: true)
    loop(winInfo)


    # We break out of the loop when the exit button is pressed.
    Logger.info("Menu Test Exiting")
    {:ok, self()}
  end

  defp loop(winInfo) do
    event = getEvent(1)
    Logger.info("Received event: #{inspect(event)}")

    case event do
      #{:msg_dlg_test, _, _} ->
      #  #WxMessageDialogTest.run()
      #  loop(winInfo)

        {_, :close_window, :wxClose} ->
          Logger.debug("Window closed")
          closeWindow(MenuTestWindow)


        {:exit_btn, _, _} ->
          closeWindow(MenuTestWindow)

        {:menu_test, :command_button_clicked, :wxCommand} ->
            closeWindow(MenuTestWindow)

          {:exit, :command_menu_selected, :wxCommand} ->
            closeWindow(MenuTestWindow)

          {item, :command_menu_selected, :wxCommand} ->
            #setStatusText(:main_frame, "#{inspect(item)} menu clicked")
            loop(winInfo)

      :timeout ->
        Logger.debug("Menu test loop")
        loop(winInfo)

      _ ->
        Logger.error("Unexpected event #{inspect(event)} in main loop")
    end
  end

  def windowClosed(event, eventSource, windowData) do
    Logger.debug("windowClosed(#{inspect(event)})")
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
