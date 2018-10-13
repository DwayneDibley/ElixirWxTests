defmodule WxDsl do
  @moduledoc """
  ## The DSL implementation
  """
  defmacro __using__(_opts) do
    quote do
      import WxDsl
      require Logger
      import WxFunctions
      import WxUtilities
      import WinInfo
      use WxDefines
    end
  end

  require Logger

  @doc """
  ```
  Performs the initialisation for the persistent storage.

  ## Parameters

    - name: String that represents the name of the person.

  """
  defmacro window(attributes, do: block) do
    quote do
      Logger.debug("")
      Logger.debug("Window +++++++++++++++++++++++++++++++++++++++++++++++++++++")
      # initialise persitant storage
      {:ok, var!(stack, Dsl)} = new_stack()
      {:ok, var!(info, Dsl)} = new_info()
      {:ok, var!(xref, Dsl)} = new_xref()

      # Get the function attributes
      opts = get_opts_map(unquote(attributes))

      # Create the windoe storage
      # winInfo = :ets.new(__ENV__.module, [:set, :protected, :named_table])
      new_table()
      put_table({:__main_thread__, -1, self()})

      # Create a new wxObject for the window
      wx = :wx.new()

      # put it on the stack
      stack_push({wx, nil})

      # put_info( :window, wx)
      put_table({:window, -1, wx})

      # execute the function body
      unquote(block)

      {parent, frame} = stack_tos()

      # if show: true, show the window
      show = Map.get(opts, :show, true)

      case show do
        [show: true] ->
          Logger.debug(":wxWindow.show(#{inspect(frame)}")
          # :wxWindow.show(frame)
          :wxFrame.show(frame)

        [show: false] ->
          nil
      end

      display_table(__ENV__.module)
      Logger.debug("Window -----------------------------------------------------")
      Logger.debug("")

      # Loop despatching events as they arrive
      WxEvents.windowEventLoop(__ENV__.module)
    end
  end

  @doc """
  Macro to set up the event connections for the window.
  The attributes consist of one of the following:
  {<event>: callback | nil, <option>: value, ...}

  <event may be one of:
    :command_button_clicked
    :close_window
    :timeout                  # This is a function to be called repeatedly every
                              # n seconds where n is given by the :delay options
                              # in milliseconds (default 1000 (1 second))

  if a callback is supplied it must have arity 4.
  """
  defmacro events(attributes) do
    quote do
      Logger.debug("events: #{inspect(unquote(attributes))}")

      window = __ENV__.module

      {_, _, parent} = WinInfo.get_by_name(:__main_frame__)
      WxEvents.setEvents(window, parent, unquote(attributes))
    end
  end

  ## ===========================================================================
  defmacro frame(attributes, do: block) do
    quote do
      Logger.debug("Frame +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {parent, container} = stack_tos()
      Logger.debug("  frame: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")

      args_dict = Enum.into(unquote(attributes), %{})

      opts_list =
        Enum.filter(unquote(attributes), fn attr ->
          case attr do
            {:id, _} -> false
            {:title, _} -> false
            {:pos, {_, _}} -> true
            {:size, {_, _}} -> true
            {:style, _} -> true
            {:name, _} -> false
            {arg, argv} -> Logger.error("    Illegal option #{inspect(arg)}: #{inspect(argv)}")
          end
        end)

      new_id = :wx_misc.newId()

      Logger.debug(
        "  :wxFrame.new(#{inspect(parent)}, #{inspect(new_id)}, #{
          inspect(Map.get(args_dict, :title, "No title"))
        },#{inspect(opts_list)}"
      )

      frame =
        :wxFrame.new(
          parent,
          # window id
          new_id,
          # window title
          Map.get(args_dict, :title, "No title"),
          opts_list
          # [{:size, Map.get(opts, :size, {600, 400})}]
        )

      Logger.debug("  Frame = #{inspect(frame)}")

      case parent do
        # put_info(:__main_frame__, frame)
        {:wx_ref, _, :wx, _} ->
          put_table({:__main_frame__, new_id, frame})

        _ ->
          false
      end

      stack_push({frame, frame})

      put_table({Map.get(args_dict, :id, nil), new_id, frame})
      # put_info(Map.get(args_dict, :id, nil), frame)
      put_xref(new_id, Map.get(args_dict, :id, nil))

      unquote(block)
      Logger.debug("Frame -----------------------------------------------------")

      frame
    end
  end

  ## ---------------------------------------------------------------------------
  ## Panel
  ## ---------------------------------------------------------------------------
  defmacro panel(attributes, do: block) do
    quote do
      {parent, container} = stack_tos()
      Logger.debug("panel: {parent, container} = #{inspect(parent)}, #{inspect(container)}})")
      new_id = :wx_misc.newId()

      args_dict = Enum.into(unquote(attributes), %{})

      opts_list =
        Enum.filter(unquote(attributes), fn attr ->
          case attr do
            {:id, _} -> false
            {:pos, {_, _}} -> true
            {:size, {_, _}} -> true
            {:style, _} -> true
            {arg, argv} -> Logger.error("    Illegal option #{inspect(arg)}: #{inspect(argv)}")
          end
        end)

      Logger.debug("  :wxPanel.new(#{inspect(parent)}")
      panel = :wxPanel.new(parent, size: {100, 100})

      put_table({Map.get(args_dict, :id, nil), new_id, panel})

      # put_info(Map.get(args_dict, :id, nil), panel)
      put_xref(new_id, Map.get(args_dict, :id, nil))

      stack_push({panel, panel})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      Logger.debug("panel: ================================")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Sizers
  ## ---------------------------------------------------------------------------

  defmacro staticBoxSizer(attributes, do: block) do
    quote do
      {parent, container} = stack_tos()

      Logger.debug(
        "staticBoxSizer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}"
      )

      # parent = stack_tos()
      # opts = get_opts_map(unquote(attributes))

      args_dict = Enum.into(unquote(attributes), %{})

      opts_list =
        Enum.filter(unquote(attributes), fn attr ->
          case attr do
            {:id, _} ->
              false

            {:orient, _} ->
              false

            {:label, _} ->
              true

            {arg, argv} ->
              Logger.error("staicBoxSizer: Illegal option {#{inspect(arg)} #{inspect(argv)}}")
              false
          end
        end)

      # opts_list = Enum.scan(opts_list, fn {k, v} -> {k, v} end)
      Logger.debug("  opts = #{inspect(opts_list)}")
      # bs = :wxBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL))

      # get the first frame element from the bottom of the stack
      # frame = bos_stack(var!(stack, Dsl))

      Logger.debug(
        "    :wxStaticBoxSizer.new(#{inspect(Map.get(args_dict, :orient, @wxHORIZONTAL))},#{
          inspect(container)
        }, #{inspect(opts_list)})"
      )

      bs = :wxStaticBoxSizer.new(Map.get(args_dict, :orient, @wxHORIZONTAL), container, opts_list)

      stack_push({bs, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(parent, bs)
      end

      Logger.debug("staticBoxSizer: ================================")
    end
  end

  defmacro boxSizer(attributes, do: block) do
    quote do
      {parent, container} = stack_tos()
      Logger.debug("boxSizer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")
      opts = get_opts_map(unquote(attributes))

      Logger.debug("  opts = #{inspect(opts)}")

      # mnu = :wxMenu.new()
      # :wxMenuBar.append(parent, mnu, Map.get(opts, :text, "&????"))
      Logger.debug("  :wxBoxSizer.new(#{inspect(Map.get(opts, :orient, @wxHORIZONTAL))})")
      bs = :wxBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL))

      stack_push({bs, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      # If this is the top level sizer, set it in the panel.
      if parent == container do
        Logger.debug("  :wxPanel.setSizer(#{inspect(parent)}, #{inspect(bs)})")
        :wxPanel.setSizer(parent, bs)
      end

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(parent, bs)

        other ->
          :ok
      end

      Logger.debug("boxSizer: ================================")
    end
  end

  defmacro spacer(attributes) do
    quote do
      parent = stack_tos()
      {parent, container} = stack_tos()
      Logger.debug("spacer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")

      opts = get_opts_map(unquote(attributes))
      Logger.debug("  opts=#{inspect(opts)}")

      Logger.debug(
        "  :wxSizer.addSpacer(#{inspect(parent)}, #{inspect(Map.get(opts, :space, 0))})"
      )

      :wxSizer.addSpacer(parent, Map.get(opts, :space, 0))
    end
  end

  ## ---------------------------------------------------------------------------
  ## Text controls
  ## ---------------------------------------------------------------------------

  defmacro textControl(attributes) do
    quote do
      {parent, container} = stack_tos()

      Logger.debug(
        "textControl: {parent, container} = #{inspect(parent)}, #{inspect(container)}}"
      )

      new_id = :wx_misc.newId()
      attributes = unquote(attributes)
      Logger.debug("  textCtrl: attributes=#{inspect(attributes)}")

      attrs = get_opts_map(attributes)

      options =
        Enum.filter(attributes, fn attr ->
          case attr do
            {:value, _} ->
              true

            {:id, _} ->
              false

            _ ->
              Logger.debug("  textCtrl: invalid attribute")
              false
          end
        end)

      Logger.debug("  :wxTextCtrl.new(#{inspect(container)}, new_id, #{inspect(options)})")
      tc = :wxTextCtrl.new(container, new_id, options)

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(tc)}), []")
          :wxBoxSizer.add(parent, tc, [])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(tc)}), []")
          :wxStaticBoxSizer.add(parent, tc, [])
      end

      put_table({Map.get(attrs, :id, nil), new_id, tc})

      # put_info(Map.get(attrs, :id, :unknown), tc)
      put_xref(new_id, Map.get(attrs, :id, :unknown))

      Logger.debug("textCtrl: ================================")

      # stack_push( sb)
      # unquote(block)
    end
  end

  defmacro staticText(attributes) do
    quote do
      {parent, container} = stack_tos()

      Logger.debug("staticText: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")

      attributes = unquote(attributes)
      Logger.debug("  attributes=#{inspect(attributes)}")

      new_id = :wx_misc.newId()

      attrs = get_opts_map(attributes)

      options =
        Enum.filter(attributes, fn attr ->
          case attr do
            {:xxx, _} ->
              true

            _ ->
              Logger.debug("  invalid attribute")
              false
          end
        end)

      Logger.debug("  :wxStaticText.new(#{inspect(container)}, 1001, #{inspect(options)})")
      st = :wxStaticText.new(container, new_id, Map.get(attrs, :text, "no text"), [])

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(st)}), []")
          :wxBoxSizer.add(parent, st, [])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(st)}), []")
          :wxStaticBoxSizer.add(parent, st, [])
      end

      put_table({Map.get(attrs, :id, nil), new_id, st})

      # put_info(Map.get(attrs, :id, :unknown), st)
      put_xref(new_id, Map.get(attrs, :id, :unknown))

      Logger.debug("staticText: ================================")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Buttons
  ## ---------------------------------------------------------------------------
  defmacro button(attributes) do
    quote do
      {parent, container} = stack_tos()

      Logger.debug("button: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")

      attributes = unquote(attributes)
      new_id = :wx_misc.newId()

      # attrs = get_opts_map(attributes)

      # {id, attributes} = List.keytake(attributes, :id, 0)
      defaults = [id: :unknown, label: "??", size: nil]
      {id, options, errors} = WxUtilities.getOptions(attributes, defaults)

      # id =
      #  case id do
      #    nil -> :unknown_event
      #    {:id, id} -> id
      #  end

      # {options, errors} = WxUtilities.getOptions(attributes, [:size, :label])

      Logger.debug(
        "  :button.new(#{inspect(container)}, #{inspect(new_id)}, #{inspect(options)})"
      )

      bt = :wxButton.new(container, new_id, options)

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bt)}), []")
          :wxBoxSizer.add(parent, bt, [])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bt)}), []")
          :wxStaticBoxSizer.add(parent, bt, [])
      end

      put_table({id, new_id, bt})

      # put_info(var!(info, Dsl), id, bt)
      # put_xref(var!(xref, Dsl), new_id, id)

      # stack_push( sb)
      # unquote(block)
      Logger.debug("button: ================================")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Tool Bar
  ## ---------------------------------------------------------------------------
  defmacro toolBar(_attributes, do: block) do
    quote do
      Logger.debug("Tool bar")

      {parent, container} = stack_tos()

      # toolbar = :wx.toolBar(parent, -1, style = @TB_HORIZONTAL | @NO_BORDER)
      tb = :wxFrame.createToolBar(parent)
      # toolbar = :wx.toolBar(parent, -1, style = @TB_HORIZONTAL)
      :wxFrame.setToolBar(parent, tb)

      IO.inspect("XPM = #{inspect(@wxBITMAP_TYPE_XPM)}")
      ficon = "/Users/rwe/elixir/dsl/images/sample.xpm"
      icon = :wxIcon.new(ficon, [{:type, @wxBITMAP_TYPE_XPM}])
      IO.inspect("Icon = #{inspect(icon)}")

      IO.inspect("XPM = #{inspect(@wxBITMAP_TYPE_XPM)}")
      ficon = "/Users/rwe/elixir/dsl/images/sample.xpm"
      bitmap = :wxBitmap.new(ficon)
      IO.inspect("bitmap = #{inspect(bitmap)}")

      # :wxToolBar.addTool(tb, 105, bitmap)

      stack_push({tb, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      :wxToolBar.realize(tb)
    end
  end

  defmacro tool(attributes) do
    quote do
      {parent, container} = stack_tos()
      Logger.debug("tool: parent =  #{inspect(parent)}")

      attributes = unquote(attributes)
      Logger.debug("attributes=#{inspect(attributes)}")

      options =
        Enum.filter(attributes, fn attr ->
          Logger.debug("IN")
          Logger.debug("#{inspect(parent)}")

          case attr do
            {:id, _} ->
              true

            {:bitmap, fileName} ->
              Logger.debug("BITMAP")
              # ficon = "/Users/rwe/elixir/dsl/images/sample.xpm"
              bitmap = :wxBitmap.new(fileName)
              IO.inspect(" bitmap  = #{inspect(bitmap)}")
              :wxToolBar.addTool(parent, 105, bitmap)
              false

            {:icon, fileName} ->
              Logger.debug("ICON")
              icon = :wxIcon.new(fileName, [{:type, @wxBITMAP_TYPE_ICO}])
              IO.inspect("Icon = #{inspect(icon)}")

              bitmap = :wxBitmap.new()
              :wxBitmap.copyFromIcon(bitmap, icon)

              :wxToolBar.addTool(parent, 106, bitmap)
              false

            {:png, fileName} ->
              Logger.debug("PNG")

              bitmap = :wxBitmap.new()
              x = :wxBitmap.loadFile(bitmap, fileName, [{:type, @wxBITMAP_TYPE_PNG}])
              IO.inspect("x = #{inspect(x)}")
              IO.inspect("png = #{inspect(bitmap)}")

              :wxToolBar.addTool(parent, 106, bitmap)
              false

            {:number, val} ->
              true

            _ ->
              Logger.debug("invalid attribute")
              false
          end
        end)

      Logger.debug("AFTER")
      # put_info(var!(info, Dsl), Map.get(opts, :id, :unknown), mi)
      # put_xref(var!(xref, Dsl), new_id, Map.get(opts, :id, :unknown))

      # stack_push( sb)
      # unquote(block)
    end
  end

  ## ---------------------------------------------------------------------------
  ## Status Bar
  ## ---------------------------------------------------------------------------
  defmacro statusBar(attributes, do: block) do
    quote do
      Logger.debug("Status Bar +++++++++++++++++++++++++++++++++++++++++++++++++")

      Logger.debug("Status bar with opts")
      {parent, container} = stack_tos()
      new_id = :wx_misc.newId()

      sb = :wxFrame.createStatusBar(parent)
      Logger.debug(":wxFrame.createStatusBar(#{inspect(parent)}) => #{inspect(sb)}")
      do_status_bar_opts(parent, unquote(attributes))

      # put_info(var!(info, Dsl), Map.get(opts, :id, :unknown), sb)
      # put_xref(var!(xref, Dsl), new_id, Map.get(opts, :id, :unknown))
      Logger.debug("Status Bar -------------------------------------------------")
      unquote(block)
    end
  end

  defmacro statusBar(attributes) do
    quote do
      Logger.debug("Status Bar +++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      # attrs = get_attrs(unquote(attributes))
      # attrs = Map.put(attrs, :id, :wx_misc.newId())
      attributes1 = [{:id, :wx_misc.newId()} | unquote(attributes)]
      Logger.debug("  attributes1=#{inspect(attributes1)}")

      options =
        Enum.filter(attributes1, fn attr ->
          case attr do
            {:id, _} -> true
            {:text, _} -> false
            {:number, val} -> true
            _ -> false
          end
        end)

      sb = :wxFrame.createStatusBar(parent, options)

      Enum.filter(attributes1, fn attr ->
        case attr do
          {:id, _} ->
            true

          {:text, val} ->
            setSbText(sb, val)

          {:number, val} ->
            true

          _ ->
            false
        end
      end)

      Logger.debug("  options=#{inspect(options)}")

      # options = []

      # wxCAPTION | wxMINIMIZE_BOX | wxMAXIMIZE_BOX | wxRESIZE_BORDER

      # do_status_bar_opts(parent, sb, unquote(attributes))

      # put_info(var!(info, Dsl), Map.get(opts, :id, :unknown), sb)
      # put_xref(var!(xref, Dsl), new_id, Map.get(opts, :id, :unknown))
      Logger.debug("Status Bar -------------------------------------------------")
    end
  end

  def setSbText(sb, text) when is_binary(text), do: :wxStatusBar.setStatusText(sb, text)

  def setSbText(sb, text) when is_list(text) do
    :wxStatusBar.setFieldsCount(sb, length(text))
    setSbTextList(sb, text, 0)
  end

  def setSbTextList(_, [], _), do: :ok

  def setSbTextList(sb, [h | t], n) do
    :wxStatusBar.setStatusText(sb, h, [{:number, n}])
    setSbTextList(sb, t, n + 1)
  end

  ## ----------------------------------------------------------------------------
  defmacro menuBar(do: block) do
    quote do
      Logger.debug("Menu Bar +++++++++++++++++++++++++++++++++++++++++++++++++++")

      {parent, container} = stack_tos()

      mb = :wxMenuBar.new()
      Logger.debug(":wxMenuBar.new() => #{inspect(mb)}")

      stack_push({mb, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      ret = :wxFrame.setMenuBar(parent, mb)
      Logger.debug(":wxFrame.setMenuBar(#{inspect(parent)}, #{inspect(mb)}) => #{inspect(ret)}")

      Logger.debug("Menu Bar ---------------------------------------------------")
    end
  end

  ## ===========================================================================
  defmacro menu(attributes, do: block) do
    quote do
      Logger.debug("  Menu +++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      opts = get_opts_map(unquote(attributes))

      mnu = :wxMenu.new()
      Logger.debug("  :wxMenu.new() => #{inspect(mnu)}")

      t = Map.get(opts, :text, "&????")

      stack_push({mnu, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      ret = :wxMenuBar.append(parent, mnu, t)

      Logger.debug(
        "  :wxMenuBar.append(#{inspect(parent)}, #{inspect(mnu)}, #{inspect(t)}) => #{
          inspect(ret)
        }"
      )

      Logger.debug("  Menu -------------------------------------------------------")
    end
  end

  ## -----------------------------------------------------------------------------
  defmacro menuItem(attributes) do
    quote do
      Logger.debug("    Menu Item ++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      defaults = [id: :unknown, text: "??"]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      # opts = get_opts_map(unquote(attributes))
      # {options, errors} = WxUtilities.getOptions(unquote(attributes), [:id, :text])
      # options = Enum.into(options, %{})

      new_id = :wx_misc.newId()

      Logger.debug("    New Menu Item: #{inspect(options)}")

      # text = Map.get(options, :text, "&????")

      mi =
        :wxMenuItem.new([
          # {:id, Map.get(opts, :id, -1)},
          {:id, new_id},
          {:text, options[:text]}
        ])

      Logger.debug(
        "    :wxMenuItem.new([{:id, #{inspect(new_id)}}, {:text, #{inspect(options[:text])}}]) => #{
          inspect(mi)
        }"
      )

      put_table({id, new_id, mi})

      # put_info(Map.get(opts, :id, :unknown), mi)
      # put_xref(new_id, Map.get(opts, :id, :unknown))
      # put_table({id, new_id, bt})

      ret = :wxMenu.append(parent, mi)
      Logger.debug("    :wxMenu.append(#{inspect(parent)}, #{inspect(mi)}) => #{inspect(ret)}")

      # stack_push( sb)
      # unquote(block)
      Logger.debug("    MenuItem  --------------------------------------------------")
    end
  end

  defmacro menuSeparator() do
    quote do
      Logger.debug("    Menu Separator +++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      new_id = :wx_misc.newId()

      Logger.debug("    New Menu Separator")

      :wxMenu.appendSeparator(parent)

      # put_info(Map.get(opts, :id, :unknown), mi)
      # put_xref(new_id, Map.get(opts, :id, :unknown))

      Logger.debug("    Menu Separator  ----------------------------------------")
    end
  end

  def setEvents(events) do
    setEvents(events, WinInfo.get_by_name(:__main_frame__))
  end

  def setEvents([], _) do
    :ok
  end

  def setEvents([event | events], parent) do
    Logger.info("setEvents: #{inspect(event)}")

    case event do
      {:timeout, func} ->
        :ok

      {evt, nil} ->
        options = [userData: __ENV__.module]
        :wxEvtHandler.connect(parent, evt, options)

      {evt, callback} ->
        options = [userData: __ENV__.module]
        :wxEvtHandler.connect(parent, evt, options)
        # {evt, callback, options} -> options = [{userData: window} | options]
        #                        :wxEvtHandler.connect(parent, evt, options)
    end

    setEvents(events, parent)
  end

  def dispatchEvent(event, eventList) do
  end

  def eventLoop() do
  end

  defmacro event(eventType) do
    quote do
      Logger.debug("Event")
      {parent, container} = stack_tos()

      # Logger.debug("  :wxEvtHandler.connect(#{inspect(parent)}, #{inspect(unquote(eventType))})")
      new_id = :wx_misc.newId()

      options = [
        # id: new_id,
        userData: __ENV__.module
      ]

      :wxEvtHandler.connect(parent, unquote(eventType), options)

      Logger.debug(
        "  :wxEvtHandler.connect(#{inspect(parent)}, #{inspect(unquote(eventType))}, #{
          inspect(options)
        }"
      )

      put_table({unquote(eventType), new_id, nil})
    end
  end

  defmacro event(eventType, callBack) do
    quote do
      # put_table({Map.get(opts, :id, :unknown), new_id, mi})
      put_info(var!(info, Dsl), unquote(eventType), unquote(callBack))

      # WinInfo.get_by_name( name)

      # put_info(eventType, callBack)
      # Agent.update(state, &Map.put(&1, unquote(eventType), unquote(callBack)))
      {parent, container} = stack_tos()
      new_id = :wx_misc.newId()

      options = [
        # id: new_id,
        callback: &WxFunctions.eventCallback/2,
        userData: __ENV__.module
      ]

      :wxEvtHandler.connect(parent, unquote(eventType), options)

      put_table({unquote(eventType), new_id, unquote(callBack)})
    end
  end

  # ==============================================================================

  def get_opts_map(opts) do
    get_opts_map(opts, [])
  end

  def get_opts_map([], opts) do
    Enum.into(opts, %{})
  end

  def get_opts_map([next | attrs], args) do
    get_opts_map(attrs, [next | args])
  end

  def get_attrs(attributes) do
    get_attrs(attributes, %{})
  end

  def get_attrs([], attrs) do
    attrs
  end

  def get_attrs([{key, val} | t], attrs) do
    newMap = Map.put(attrs, key, val)
    get_attrs(t, newMap)
  end

  # Persistent storage =========================================================
  # window info
  def new_info(), do: Agent.start_link(fn -> %{} end)
  def end_info(state), do: Agent.stop(state)

  # this is for the event case which otherwise gives an error because of the fn ref
  def put_info(state, key, value),
    do: Agent.update(state, &Map.put(&1, key, value))

  defmacro put_info(key, value) do
    quote do
      Agent.update(var!(info, Dsl), &Map.put(&1, unquote(key), unquote(value)))
    end
  end

  def get_info(state, key), do: Agent.get(state, &Map.get(&1, key))
  # def get_info(state), do: Agent.get(state, & &1)

  defmacro get_info() do
    quote do
      Agent.get(var!(info, Dsl), & &1)
    end
  end

  # ===========================
  # id to name cross reference
  # ===========================
  def new_xref(), do: Agent.start_link(fn -> %{} end)
  def end_xref(xref), do: Agent.stop(xref)

  def put_xref(xref, key, value),
    do: Agent.update(xref, &Map.put(&1, key, value))

  defmacro put_xref(key, value) do
    quote do
      Agent.update(var!(xref, Dsl), &Map.put(&1, unquote(key), unquote(value)))
    end
  end

  def get_xref(xref, key), do: Agent.get(xref, &Map.get(&1, key))
  # def get_xref(xref), do: Agent.get(xref, & &1)

  defmacro get_xref() do
    quote do
      Agent.get(var!(xref, Dsl), & &1)
    end
  end

  # ===========================
  # Persistent stack
  # ===========================
  def new_stack(), do: Agent.start_link(fn -> [] end)
  def end_stack(stack), do: Agent.stop(stack)

  def push_stack(stack, value),
    do: Agent.update(stack, fn stack -> [value | stack] end)

  defmacro stack_push(value) do
    quote do
      Agent.update(var!(stack, Dsl), fn stack -> [unquote(value) | stack] end)
    end
  end

  def tos_stack(stack) do
    Agent.get(stack, &List.first(&1))
  end

  defmacro stack_tos() do
    quote do
      Agent.get(var!(stack, Dsl), &List.first(&1))
    end
  end

  def bos_stack(stack) do
    Agent.get(stack, &List.last(&1))
  end

  def pop_stack(stack) do
    {tos, rest} = Agent.get(stack, &List.pop_at(&1, 0))
    Agent.update(stack, fn _stack -> rest end)
    tos
  end

  def is_member(list, item) do
    Enum.find(list, fn x -> x == item end)
  end
end
