defmodule WxWinObj do
  use GenServer
  require Logger

  @moduledoc """
  This object creates, encapsulates and provides an interface to a window.
  """

  ## Client API ----------------------------------------------------------------
  @doc """
  Create and optionally show a window.

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
  def start_link(window_spec, evt_handler, options \\ []) when is_atom(window_spec) do
    GenServer.start_link(__MODULE__, {self(), window_spec, evt_handler, options})
  end

  @doc """
  See start_link()
  """
  def start(window_spec, evt_handler, options \\ []) when is_atom(window_spec) do
    GenServer.start_link(__MODULE__, {self(), window_spec, evt_handler, options})
  end

  @doc """
  Show the specified window.
  ```
  show(pid)
  ```
  """
  def show(window) do
    GenServer.cast(window, {:show, true})
  end

  @doc """
  Hide the specified window.
  ```
  hide(window)
  ```
  """
  def hide(window) do
    GenServer.cast(window, {:show, false})
  end

  @doc """
  Set the given attribute value.

  window: Atom; The name of the window (see start_link())
  obj: Atom; The name of the window element.
  attr: Atom; The name of the attribute to be retrieved
  value: Term; The value to set the attribute to.
  ```
  setAttr(:my_window, :ok_button, :size, {100, 200})
  ```
  """
  def setAttr(window, obj, attr, value) do
    GenServer.cast(window, {:set, {obj, attr, value}})
  end

  @doc """
  Get the given attribute value.

  window: Atom; The name of the window (see start_link())
  obj: Atom; The name of the window element.
  attr: Atom; The name of the attribute to be retrieved

  returns the value of the attribute.

  ```
  getAttr(:my_window, :ok_button, :text)
  ```
  """
  def getAttr(window, obj, attr) do
    GenServer.call(window, {:get, {obj, attr}})
  end

  @doc """
  Set the status bar text.
  """
  def statusBarText(pid, text, index \\ 0) when is_binary(text) or is_list(text) do
    GenServer.cast(pid, {:statusBarText, text, index})
  end

  ## Server Callbacks ----------------------------------------------------------
  @impl true
  def init({parent, window_spec, evt_handler, options}) do
    Process.monitor(parent)


    name =
      case options[:name] do
        nil -> window_spec
        name -> name
      end

    # Check that the window definition file exists
    window_spec =
      case Code.ensure_loaded(window_spec) do
        {:error, :nofile} ->
          Logger.error("No such window specification: #{inspect(window_spec)}")
          nil

        # {:stop, "No such module: #{inspect(window)}"}
        {:module, _} ->
          window_spec
      end

    # Check that the evt_handler definition file exists. It may be null
    # if we dont want to handle any events.
    {evt_handler, handler_fns} =
      case evt_handler do
        nil ->
          {nil, []}

        _ ->
          case Code.ensure_loaded(evt_handler) do
            {:error, :nofile} ->
              Logger.warn("Event handler: No such module: #{inspect(evt_handler)}")
              {nil, []}

            {:module, _} ->
              {evt_handler, evt_handler.module_info(:exports)}
          end
      end

    case {window_spec, evt_handler, handler_fns} do
      {nil, _, _} ->
        {:stop, "No such module: #{inspect(window_spec)}"}

      {window_spec, nil, _} ->
        win = window_spec.createWindow(show: options[:show])

        {:ok,
         [
           parent: parent,
           winName: name,
           winInfo: win,
           window: window_spec,
           handler: nil,
           handler_fns: []
         ]}

      {window_spec, evt_handler, handler_fns} ->
        win = window_spec.createWindow(show: options[:show])

        {:ok,
         [
           parent: parent,
           winName: name,
           winInfo: win,
           window: window_spec,
           handler: evt_handler,
           handler_fns: handler_fns
         ]}
    end

  end

  # Call interface ----
  @impl true
  def handle_call({:get, {obj, attr}}, from, state) do
    #attr = WxAttributes.getAttr(obj, attr)
    {:reply, attr, state}
  end

  # Cast interface ----
  @impl true
  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  @impl true
  def handle_cast({:show, how}, state) do
    Logger.info("Show!!")
    {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
    :wxFrame.show(frame)
    {:noreply, state}
  end

@impl true
  def handle_cast({:set, {obj, attr, val}}, state) do
    #WxAttributes.setAttr(obj, attr, val)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:statusBarText, text, index}, state) do
    Logger.info("Show!!: #{inspect(text)}, #{inspect(index)}")

    # WxWindow.show(how)
    {:noreply, state}
  end

  # Gen_server callbacks ---------------------------------------------------------
  @impl true
  def terminate(reason, msg) do
    Logger.info("terminate: #{inspect(reason)}, #{inspect(msg)}")
  end

  # Handle Info
  def handle_info({_, _, sender, _, {:wxClose, :close_window}}, state) do

    send(state[:parent], {state[:winName], :child_window_closed, "Close window event"})

    # WxFunctions.closeWindow(state[:window])
    {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
    :wxEvtHandler.disconnect(frame)
    :wxWindow.destroy(frame)
    {:stop, :normal, "#{inspect(state[:winName])} - Close window event"}
  end

  # Menu event
  def handle_info(
        {_, sender, _, _, {:wxCommand, :command_menu_selected, _, _, _}},
        state
      ) do
    invokeEventHandler(:do_menu_click, sender, state)
    {:noreply, state}
  end

  # Menu event
  def handle_info(
        {_, sender, _, _, {:wxCommand, :command_button_clicked, _, _, _}},
        state
      ) do
    invokeEventHandler(:do_button_click, sender, state)
    {:noreply, state}
  end

  # Child window closed event received
  def handle_info(
        {window, :child_window_closed, reason},
        state
      ) do
    invokeEventHandler(:do_child_window_closed, window, state)
    {:noreply, state}
  end

  # Child window closed event received
  def handle_info(
        {:DOWN, _, :process, pid, how},
        state
      ) do

    parent = state[:parent]
    xxx = case pid == parent do
      true -> Logger.info("Parent window exited: #{inspect(how)}")
      false -> Logger.info("Window exit event caught: #{inspect(pid)}")
    end
    invokeEventHandler(:do_parent_window_closed, pid, state)
    {:stop, :normal, "Parent died"}
  end


  @impl true
  def handle_info(msg, state) do
    Logger.info("#{inspect(state[:winName])} - handle Info: #{inspect(msg)}, #{inspect(state)}")
    {:noreply, state}
  end

  # Helper functions ===========================================================
  defp invokeEventHandler(:child_window_closed, sender, state) do
    event = :child_window_closed

    case state[:handler_fns][event] do
      nil ->
        Logger.info(
          "#{inspect(state[:winName])} - unhandled #{inspect(event)} event from #{
            inspect(inspect(sender))
          }"
        )

      1 ->
        Code.eval_string("#{state[:handler]}.#{event}(#{inspect(sender)})")
    end
  end

  defp invokeEventHandler(event, sender, state) do
    {name, _id, _obj} = WinInfo.get_by_id(sender)

    case state[:handler_fns][event] do
      nil ->
        Logger.info(
          "#{inspect(state[:winName])} - unhandled #{event} event: #{inspect(inspect(name))}"
        )

      #      1 -> state[:handler].event.(sender)
      1 ->
        Code.eval_string("#{state[:handler]}.#{event}(#{inspect(name)})")
    end
  end
end
