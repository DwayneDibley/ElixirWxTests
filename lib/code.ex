defmodule CodeWindow do
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
  Then loop waiting for events.menu event xxx

  """
  def run(file, parent \\ nil) do
    try do
      _window = CodeWindowWindow.createWindow(file, true, parent)
    rescue
      e in RuntimeError -> Logger.error("Exiting main loop: #{inspect(e)}")
    end

    Logger.info("#{inspect(__ENV__.file)}")

    # We break out of the loop when the exit button is pressed.
    Logger.info("ElixirWx Test Exiting")

    # case parent do
    #  nil -> nil
    #  parent -> send(parent, {:window_closed, CodeWindowWindow, self()})
    # end

    {:ok, self()}
  end
end
