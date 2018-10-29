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
  Show the window.
  ```
  show(pid)
  ```
  """
  def show(window) do
    GenServer.cast(window, {:show, true})
  end

  @doc """
  Hide the window.
  ```
  hide(window)
  ```
  """
  def hide(window) do
    GenServer.cast(window, {:show, false})
  end

  def set(window, obj, attr, value) do
    GenServer.cast(window, {:set, {obj, attr, value}})
  end

  def get(window, obj, attr) do
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
    Logger.info(
      "Object init: #{inspect(parent)}, #{inspect(window_spec)}, #{inspect(evt_handler)}, #{
        inspect(options)
      }
      }"
    )

    name =
      case options[:name] do
        nil -> window_spec
        name -> name
      end

    Logger.info("name = #{inspect(name)}")

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
          Logger.debug("No event handler...")
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

    Logger.error("evt_handler = #{inspect(evt_handler)}, handler_fns = #{inspect(handler_fns)}")

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
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call({:get, {obj, attr}}, state) do
    attr = WxAttributes.getAttr(obj, attr)
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

  def handle_cast({:set, {obj, attr, val}}, state) do
    WxAttributes.setAttr(obj, attr, val)
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
    Logger.info("close window: #{inspect(sender)}, #{inspect(state)}")

    Logger.info(
      "close send event: #{inspect(state[:parent])}, #{inspect(state[:winName])}, :window_closed, Close window event"
    )

    send(state[:parent], {state[:winName], :window_closed, "Close window event"})

    # WxFunctions.closeWindow(state[:window])
    {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
    :wxEvtHandler.disconnect(frame)
    :wxWindow.destroy(frame)
    {:stop, :normal, "Close window event"}
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

  @impl true
  def handle_info(msg, state) do
    Logger.info("handle Info: #{inspect(msg)}, #{inspect(state)}")
    {:noreply, state}
  end

  # Helper functions ===========================================================
  defp invokeEventHandler(event, sender, state) do
    Logger.info("state = #{inspect(state)}")
    Logger.info("functions = #{inspect(state[:handler_fns])}")
    Logger.info("arity = #{inspect(state[:handler_fns][event])}")

    Logger.info("#{state[:handler]}.#{event}(#{sender})")
    # eval_string(string, binding \\ [], opts \\ [])

    {name, _id, _obj} = WinInfo.get_by_id(sender)

    case state[:handler_fns][event] do
      nil ->
        Logger.info("unhandled #{event} event: #{inspect(inspect(name))}")

      #      1 -> state[:handler].event.(sender)
      1 ->
        Logger.info("IN: #{state[:handler]}.#{event}(#{inspect(name)})")
        Code.eval_string("#{state[:handler]}.#{event}(#{inspect(name)})")
        Logger.info("OUT")
    end
  end
end
