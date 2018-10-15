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
      # put_xref(new_id, Map.get(args_dict, :id, nil))

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
      Logger.debug("Panel +++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      defaults = [id: :unknown, pos: nil, size: nil, style: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug("panel: {parent, container} = #{inspect(parent)}, #{inspect(container)}})")

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

      Logger.debug("  :wxPanel.new(#{inspect(parent)}, #{inspect(options)}")
      # panel = :wxPanel.new(parent, size: {100, 100})
      panel = :wxPanel.new(parent, options)

      put_table({id, new_id, panel})

      stack_push({panel, panel})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      Logger.debug("panel -----------------------------------------------------")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Sizers
  ## ---------------------------------------------------------------------------

  defmacro xstaticBoxSizer(attributes, do: block) do
    quote do
      {parent, container} = stack_tos()

      Logger.debug(
        "staticBoxSizer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}"
      )

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

      Logger.debug("  opts = #{inspect(opts_list)}")

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

      Logger.debug("  BoxSizer -----------------------------------------------------")
    end
  end

  defmacro staticBoxSizer(attributes, do: block) do
    quote do
      Logger.debug("Static Box Sizer ++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()
      Logger.debug("boxSizer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")
      opts = get_opts_map(unquote(attributes))

      Logger.debug("  opts = #{inspect(opts)}")

      Logger.debug("  :staticBoxSizer.new(@wxVertical, #{inspect(container)}, #{inspect([{:label, "wxSizer"}])}")
      #sbs = :wxStaticBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL), parent, [{:label, "wxSizer"}])
      sbs = :wxStaticBoxSizer.new(@wxHORIZONTAL, container, [{:label, "Static Box Sizer"}])
      #wxStaticBoxSizer:new(?wxVERTICAL, Panel, [{label, "wxSizer"}]),

      #:wxSizer.insertSpacer(sbs, 9999, 20)

      stack_push({sbs, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(sbs)}), []")
          :wxBoxSizer.add(parent, sbs, [{:flag, @wxEXPAND}, {:proportion, 1}])

        {:wx_ref, _, :wxPanel, []} ->
          Logger.debug("  :wxPanel.setSizer(#{inspect(parent)}, #{inspect(sbs)})")
          :wxPanel.setSizer(parent, sbs)

        other ->
          :ok
      end

      Logger.debug("Static Box Sizer ---------------------------------------------------")
    end
  end


  defmacro boxSizer(attributes, do: block) do
    quote do
      Logger.debug("Box Sizer ++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()
      Logger.debug("boxSizer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")
      opts = get_opts_map(unquote(attributes))

      Logger.debug("  opts = #{inspect(opts)}")

      # mnu = :wxMenu.new()
      # :wxMenuBar.append(parent, mnu, Map.get(opts, :text, "&????"))
      Logger.debug("  :wxBoxSizer.new(#{inspect(Map.get(opts, :orient, @wxHORIZONTAL))})")
      bs = :wxBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL))

      #:wxSizer.insertSpacer(bs, 9999, 20)

      stack_push({bs, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(parent, bs)

        {:wx_ref, _, :wxPanel, []} ->
          Logger.debug("  :wxPanel.setSizer(#{inspect(parent)}, #{inspect(bs)})")
          :wxPanel.setSizer(parent, bs)

        other ->
          :ok
      end

      Logger.debug("boxSizer ---------------------------------------------------")
    end
  end

  defmacro border(attributes) do
    quote do
      parent = stack_tos()
      {parent, container} = stack_tos()
      Logger.debug("spacer: {parent, container} = #{inspect(parent)}, #{inspect(container)}}")

      defaults = [size: 1, flags: @wxALL]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      Logger.debug(
        "  :wxSizer.insertSpacer(#{inspect(parent)}, #{inspect(Map.get(opts, :space, 0))})"
      )

      :wxSizer.addSpacer(parent, Map.get(opts, :space, 0))
      :wxSizer.insertSpacer(bs, 9999, 20)
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

      defaults = [id: :unknown, label: "??", size: nil]
      {id, options, errors} = WxUtilities.getOptions(attributes, defaults)

      Logger.debug(
        "  :button.new(#{inspect(container)}, #{inspect(new_id)}, #{inspect(options)})"
      )

      bt = :wxButton.new(container, new_id, options)

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bt)}), []")
          :wxBoxSizer.add(parent, bt, [{:flag, @wxALL}, {:proportion, 10}])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bt)}), []")
          :wxStaticBoxSizer.add(parent, bt, [{:flag, @wxALL}, {:proportion, 10}])

          #xSizer:add(Sizer, ListBox, [{flag, ?wxEXPAND}])
      end

      put_table({id, new_id, bt})

      Logger.debug("button: ================================")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Tool Bar
  ## ---------------------------------------------------------------------------
  defmacro toolBar(_attributes, do: block) do
    quote do
      Logger.debug("Tool Bar +++++++++++++++++++++++++++++++++++++++++++++++++++")

      {parent, container} = stack_tos()

      Logger.debug("  :wxFrame.createToolBar(#{inspect(parent)})")
      tb = :wxFrame.createToolBar(parent)

      stack_push({tb, container})
      unquote(block)
      pop_stack(var!(stack, Dsl))

      Logger.debug("  :wxFrame.setToolBar(#{inspect(parent)}, #{inspect(tb)})")
      :wxFrame.setToolBar(parent, tb)

      Logger.debug("  :wxToolBar.realize(#{inspect(parent)})")
      :wxToolBar.realize(tb)

      Logger.debug("Tool Bar ---------------------------------------------------")
    end
  end

  defmacro tool(attributes) do
    quote do
      Logger.debug("  Tool +++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      defaults = [id: :unknown, bitmap: nil, icon: nil, png: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      path = Path.expand(Path.dirname(__ENV__.file) <> "/../")
      Logger.debug("  path: #{inspect(path)}")

      options =
        Enum.filter(options, fn attr ->
          case attr do
            {:bitmap, fileName} ->
              Logger.debug("BITMAP")
              fileName = Path.expand(path <> "/" <> fileName)
              bitmap = :wxBitmap.new(fileName)
              t = :wxToolBar.addTool(parent, new_id, bitmap)
              put_table({id, new_id, t})
              false

            {:icon, fileName} ->
              fileName = Path.expand(path <> "/" <> fileName)
              Logger.debug(":wxIcon.new(#{inspect(fileName)}, [{:type, @wxBITMAP_TYPE_ICO}])")
              icon = :wxIcon.new(fileName, [{:type, @wxBITMAP_TYPE_ICO}])
              Logger.debug(":wxBitmap.new()")
              bitmap = :wxBitmap.new()
              Logger.debug(":wxBitmap.copyFromIcon(#{inspect(bitmap)}, #{inspect(icon)})")
              :wxBitmap.copyFromIcon(bitmap, icon)

              Logger.debug(
                ":wxToolBar.addTool(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(bitmap)})"
              )

              t = :wxToolBar.addTool(parent, new_id, bitmap)
              put_table({id, new_id, t})
              false

            {:png, fileName} ->
              fileName = Path.expand(path <> "/" <> fileName)
              bitmap = :wxBitmap.new()
              x = :wxBitmap.loadFile(bitmap, fileName, [{:type, @wxBITMAP_TYPE_PNG}])
              t = :wxToolBar.addTool(parent, new_id, bitmap)
              put_table({id, new_id, t})
              false

            _ ->
              Logger.debug("invalid attribute")
              false
          end
        end)

      Logger.debug("  Tool ---------------------------------------------------")
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

      Logger.debug("Status Bar -------------------------------------------------")
      unquote(block)
    end
  end

  defmacro statusBar(attributes) do
    quote do
      Logger.debug("Status Bar +++++++++++++++++++++++++++++++++++++++++++++++++")
      {parent, container} = stack_tos()

      defaults = [id: :status_bar, number: nil, style: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()
      options = [{:id, new_id} | options]

      Logger.debug(":wxFrame.createStatusBar(#{inspect(parent)}, #{inspect(options)})")
      sb = :wxFrame.createStatusBar(parent, options)

      put_table({id, new_id, sb})

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

      new_id = :wx_misc.newId()

      Logger.debug("    New Menu Item: #{inspect(options)}")

      mi =
        :wxMenuItem.new([
          {:id, new_id},
          {:text, options[:text]}
        ])

      Logger.debug(
        "    :wxMenuItem.new([{:id, #{inspect(new_id)}}, {:text, #{inspect(options[:text])}}]) => #{
          inspect(mi)
        }"
      )

      put_table({id, new_id, mi})

      ret = :wxMenu.append(parent, mi)
      Logger.debug("    :wxMenu.append(#{inspect(parent)}, #{inspect(mi)}) => #{inspect(ret)}")

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
