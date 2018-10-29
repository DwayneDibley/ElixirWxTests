defmodule WxWinObj.API do
  require Logger

  @moduledoc """
  An API to make using WxWindowObject simpler, and tomake sure any errors are
  reported in the callers code.
  """

  @doc """
  Create a new window and optionally show it.

  - **windowSpec**: The name of the module containing the window specification (see WxDsl).
  - **evtHandler**: The name of th emodule containing the event handling code.
  - **options**: Options when creating a window.They can be:
    * _show:_ Bool, Show the window when created(default)
    * _name:_ The name that the window will be registered with. if a name is not supplied
    or is nil, then the name of the module containing the winowSpec will be used to register the window.

    ```
    start_link(MyWindow, MyWindowEvents, show: true, name: MyWindow)
    ```

  """
  def newWindow(windowSpec, eventHandler, options \\ []) do
    case WxWindowObject.start_link(windowSpec, eventHandler, options) do
      {:ok, window} ->
        window

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Show a window.

  the window parameter may be either the name given when the window was created,
  or the PID returned by the new window call.
  """
  def showWindow(window) do
    case checkPid(window) do
      {:error, reason} -> {:error, reason}
      window -> WxWindowObject.show(window)
    end
  end

  @doc """
  Hide a window.

  the window parameter may be either the name given when the window was created,
  or the PID returned by the new window call.
  """
  def hideWindow(window) do
    case checkPid(window) do
      {:error, reason} -> {:error, reason}
      window -> WxWindowObject.show(window)
    end
  end

  @doc """
  Close a window.

  the window parameter may be either the name given when the window was created,
  or the PID returned by the new window call.
  """
  def closeWindow(window) do
    Logger.debug("closeWindow(#{inspect(window)})")

    case checkPid(window) do
      {:error, reason} -> {:error, reason}
      window -> WxWinObj.close(window)
    end
  end

  @doc """
    Wait for window to close.

    All events apart from the termiantion event from the specified window will be
    discarded. If window is nil, then a termination event from any window will cause
    a return.

    If a timeout is supplied, then waitForTermination will return after the
    specified number of seconds.

    Returns:
    - {windowName, :window_closed, reason}
    - :timeout
  """
  def waitForWindowClose(window, timeout \\ -1) when is_integer(timeout) do
    case timeout do
      -1 ->
        receive do
          {windowName, :window_closed, reason} ->
            {windowName, :window_closed, reason}

          _ ->
            waitForWindowClose(window, timeout)
        end

      timeout ->
        receive do
          {windowName, :window_closed, reason} ->
            {windowName, :window_closed, reason}

          _ ->
            waitForWindowClose(window, timeout)
        after
          timeout ->
            :timeout
        end
    end
  end

  # ----------------------------------------------------------------------------
  defp checkPid(window) when is_pid(window) or is_atom(window) do
    window
  end

  defp checkPid(_window) do
    {:error, "Window identifier must be an atom or a PID"}
  end
end
