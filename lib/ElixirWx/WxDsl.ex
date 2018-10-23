defmodule WxDsl do
  @moduledoc """
  An implementation of a DSL for generating GUI's
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
  This is the top level window and should be the outer element of a window specification. This window performs the initialisation.

  | Parameter | Description                                                  | Value     | Default                |
  | --------- | ------------------------------------------------------------ | --------- | ---------------------- |
  | name      | The name by which the window will be referred to.            | atom()    | modulename |
  | show      | If set to true the window will be made visible when the construction is complete. If set to false, the window will be invisible until explicitly shown using :wxFrame.show(frame). | Boolean() | true                   |

  Example:

  ```
  defmodule TestWindow do
    use WxDsl
    import WxDefines

    def createWindow(show) do
      mainWindow show: show do
        # Create a frame with a status bar and a menu.
        frame id: :main_frame,
        ...
        ...
        end
      end
    end

  """
  defmacro mainWindow(attributes, do: block) do
    quote do
      Logger.debug("")
      Logger.debug("mainWindow +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      # Get the function attributes
      opts = get_opts_map(unquote(attributes))

      # Create the window storage
      new_table()

      # Create a new wxObject for the window
      wx = :wx.new()

      # put_info( :window, wx)
      put_table({:window, -1, wx})

      # execute the function body
      stack_push({wx, nil, nil})
      unquote(block)
      stack_pop()

      # if show: true, show the window
      show = Map.get(opts, :show, true)

      {_, _, frame} = WinInfo.get_by_name(:__main_frame__)

      case show do
        [show: true] ->
          Logger.debug("  :wxWindow.show(#{inspect(frame)}")
          :wxFrame.show(frame)

        [show: false] ->
          nil
      end

      Logger.debug("mainWindow -----------------------------------------------------")
      display_table()
      Logger.debug("")

      WxTopLevelWindow.setIcon(Map.get(opts, :icon, nil))

      # Loop despatching events as they arrive
      WxEvents.windowEventLoop(__ENV__.module)
    end
  end

  @doc """
  Macro to set up the event connections for the window.
  The attributes consist of one of the following:
  {<event>: callback | nil, <option>: value, ...}

  event may be one of:
    :command_button_clicked
    :close_window
    :timeout                  # This is a function to be called repeatedly every
                              # n seconds where n is given by the :delay options
                              # in milliseconds (default 1000 (1 second))

  if a callback is supplied it must have arity 4.
  """
  defmacro events(attributes) do
    quote do
      Logger.debug("Events +++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      Logger.debug("  events: #{inspect(unquote(attributes))}")

      {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
      WxEvents.setEvents(__ENV__.module, frame, unquote(attributes))
      Logger.debug("Events -----------------------------------------------------")
    end
  end

  @doc """
  Create a new window.

  | attributes | Description                                                  | Value     | Default                |
  | ---------- | ------------------------------------------------------------ | --------- | ---------------------- |
  | style      | The window Style.                                            | atom()    | modulename             |
  | size       | The initial size of the window.                              | atom()    | modulename             |
  | layout     | The window layout.                                           | list      | []                     |

  Example:

  ```
  window(style: @wxBORDER_SIMPLE, size: {50, 25},
        layout: [proportion: 0, flag: @wxEXPAND]) do
    bgColour(@wxBLACK)
  end
  ```
  """
  defmacro window(attributes, do: block) do
    quote do
      Logger.debug("Window/2 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()

      {id, new_id, win} = WxWindow.new(parent, unquote(attributes))

      stack_push({container, win, sizer})
      unquote(block)
      stack_pop()

      WxSizer.add(win, sizer, unquote(attributes))

      Logger.debug("Window/2 -----------------------------------------------------")
      win
    end
  end

  defmacro window(attributes) do
    quote do
      Logger.debug("Window/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      defaults = [style: nil, size: nil]
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug("  :wxWindow.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)}")
      win = :wxWindow.new(parent, new_id, options)

      put_table({id, new_id, win})

      WxSizer.addToSizer(win, sizer, restOpts)
      Logger.debug("Window/1 -----------------------------------------------------")
      win
    end
  end

  defmacro htmlWindow(attributes) do
    quote do
      Logger.debug("htmlWindow/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      defaults = [style: nil, size: nil]
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug(
        "  :wxHtmlWindow.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)}"
      )

      win = :wxHtmlWindow.new(parent, new_id, options)

      put_table({id, new_id, win})

      WxSizer.addToSizer(win, sizer, restOpts)
      Logger.debug("htmlWindow/1 -----------------------------------------------------")
      win
    end
  end

  defmacro htmlWindow(attributes, do: block) do
    quote do
      Logger.debug("htmlWindow/2 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()

      {id, new_id, win} = WxHtmlWindow.new(parent, unquote(attributes))

      stack_push({container, win, sizer})
      unquote(block)
      stack_pop()

      WxSizer.add(win, sizer, unquote(attributes))

      Logger.debug("htmlWindow/2 -----------------------------------------------------")
      win
    end
  end

  defmacro codeWindow(attributes) do
    quote do
      Logger.debug("codeWindow/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      defaults = [style: nil, size: nil]
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug(
        "  :wxHtmlWindow.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)}"
      )

      win = :wxHtmlWindow.new(parent, new_id, options)

      put_table({id, new_id, win})

      WxSizer.addToSizer(win, sizer, restOpts)
      Logger.debug("codeWindow/1 -----------------------------------------------------")
      win
    end
  end

  defmacro codeWindow(attributes, do: block) do
    quote do
      Logger.debug("codeWindow/2 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()

      {id, new_id, win} = WxCodeWindow.new(parent, unquote(attributes))

      stack_push({container, win, sizer})
      unquote(block)
      stack_pop()

      WxSizer.add(win, sizer, unquote(attributes))

      Logger.debug("codeWindow/2 -----------------------------------------------------")
      win
    end
  end

  defmacro scrolledWindow(attributes, do: block) do
    quote do
      Logger.debug("scrolledWindow/2 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      # to be done
      defaults = []
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      defaults = [scrollRate: nil]
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug("  :wxWindow.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)}")

      # win = :wxWindow.new(parent, new_id, options)

      win = :wxScrolledWindow.new(parent, [])
      :wxScrolledWindow.setScrollRate(win, 5, 5)

      put_table({id, new_id, win})

      stack_push({container, win, sizer})
      unquote(block)
      stack_pop()

      WxSizer.addToSizer(win, sizer, restOpts)
      Logger.debug("scrolledWindow/2 -----------------------------------------------------")
      win
    end
  end

  @doc """
  Set the background colour for the enclosing control.

  The colour may be either one of the defined colours in wxDefines.ex or a nummeric
  RGB specification in the form {r, g, b}.

  ```
    bgColour(@wxSILVER)
    bgColour({{192, 192, 192}})
  ```

  """
  defmacro bgColour(colour) do
    quote do
      Logger.debug("bgColour +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      :wxWindow.setBackgroundColour(parent, unquote(colour))
      Logger.debug("bgColour -----------------------------------------------------")
    end
  end

  defmacro frame(attributes, do: block) do
    quote do
      Logger.debug("Frame +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

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
          container,
          # window id
          new_id,
          # window title
          Map.get(args_dict, :title, "No title"),
          opts_list
          # [{:size, Map.get(opts, :size, {600, 400})}]
        )

      Logger.debug("  Frame = #{inspect(frame)}")

      case container do
        # put_info(:__main_frame__, frame)
        {:wx_ref, _, :wx, _} ->
          put_table({:__main_frame__, new_id, frame})

        _ ->
          false
      end

      stack_push({frame, frame, nil})

      put_table({Map.get(args_dict, :id, nil), new_id, frame})
      # put_info(Map.get(args_dict, :id, nil), frame)
      # put_xref(new_id, Map.get(args_dict, :id, nil))

      unquote(block)
      # put_table({Map.get(args_dict, :id, nil), new_id, frame})
      stack_pop()
      Logger.debug("Frame -----------------------------------------------------")

      frame
    end
  end

  ## ---------------------------------------------------------------------------
  ## Panel xxx
  ## ---------------------------------------------------------------------------
  defmacro panel(attributes, do: block) do
    quote do
      Logger.debug("Panel +++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      defaults = [id: :unknown, pos: nil, size: nil, style: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      Logger.debug(
        "  panel: {container, parent, sizer} = #{inspect(parent)}, #{inspect(container)}})"
      )

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
      panel = :wxPanel.new(container, options)

      put_table({id, new_id, panel})

      stack_push({container, panel, sizer})
      Logger.debug("  stack_push({#{inspect(container)}, #{inspect(panel)}, #{inspect(sizer)}})")
      unquote(block)
      stack_pop()

      case sizer do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(panel)}), []")
          :wxBoxSizer.add(sizer, panel, [])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(panel)}), []")
          :wxStaticBoxSizer.add(sizer, panel, [])

        nil ->
          nil
      end

      Logger.debug("panel -----------------------------------------------------")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Sizers
  ## ---------------------------------------------------------------------------

  defmacro xstaticBoxSizer(attributes, do: block) do
    quote do
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

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
              Logger.error("  staicBoxSizer: Illegal option {#{inspect(arg)} #{inspect(argv)}}")
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

      stack_push({container, bs, sizer})
      unquote(block)
      stack_pop()

      case parent do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(parent)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(parent, bs)
      end

      Logger.debug("BoxSizer -----------------------------------------------------")
    end
  end

  defmacro staticBoxSizer(attributes, do: block) do
    quote do
      Logger.debug("Static Box Sizer ++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      opts = get_opts_map(unquote(attributes))

      Logger.debug("  opts = #{inspect(opts)}")

      Logger.debug(
        "  :staticBoxSizer.new(@wxVertical, #{inspect(container)}, #{
          inspect([{:label, "wxSizer"}])
        }"
      )

      # sbs = :wxStaticBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL), parent, [{:label, "wxSizer"}])
      sbs = :wxStaticBoxSizer.new(@wxHORIZONTAL, container, [{:label, "Static Box Sizer"}])
      # wxStaticBoxSizer:new(?wxVERTICAL, Panel, [{label, "wxSizer"}]),

      # :wxSizer.insertSpacer(sbs, 9999, 20)

      stack_push({container, parent, sbs})
      unquote(block)
      stack_pop()

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

  @doc """
  Create a new box sizer.
  """
  defmacro boxSizer(attributes, do: block) do
    quote do
      Logger.debug("Box Sizer ++++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("   tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      opts = get_opts_map(unquote(attributes))

      Logger.debug("  opts = #{inspect(opts)}")
      bs = :wxBoxSizer.new(Map.get(opts, :orient, @wxHORIZONTAL))

      Logger.debug(
        "  :wxBoxSizer.new(#{inspect(Map.get(opts, :orient, @wxHORIZONTAL))}) => #{inspect(bs)}"
      )

      # :wxSizer.insertSpacer(bs, 9999, 20)

      stack_push({container, parent, bs})
      unquote(block)
      stack_pop()

      case sizer do
        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(sizer, bs)

        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bs)}), []")
          :wxBoxSizer.add(sizer, bs)

        nil ->
          case parent do
            {:wx_ref, _, :wxPanel, []} ->
              Logger.debug("  :wxPanel.setSizer(#{inspect(parent)}, #{inspect(bs)})")
              :wxPanel.setSizer(parent, bs)

            {:wx_ref, _, :wxFrame, []} ->
              Logger.debug("  :wxWindow.setSizer(#{inspect(parent)}, #{inspect(bs)})")
              # :wxFrame.setSizerAndFit(parent, bs)
              :wxWindow.setSizer(parent, bs)

            other ->
              Logger.error("  BoxSizer: No sizer and parent = #{inspect(parent)}")
          end

        other ->
          Logger.error("  BoxSizer: sizer = #{inspect(sizer)}")
      end

      Logger.debug("boxSizer ---------------------------------------------------")
    end
  end

  defmacro layout(attributes) do
    quote do
      Logger.debug("layout ++++++++++++++++++++++++++++++++++++++++++++++++++")
      Logger.info("  layout(#{inspect(unquote(attributes))})")

      {id, {width, height}, flags} = WxLayout.getLayoutAttributes(unquote(attributes))

      case id do
        :_no_id_ -> :ok
        _ -> put_table({id, {width, height}, flags})
      end

      Logger.debug("Layout ---------------------------------------------------")

      {width, height, flags}
    end
  end

  # Update an existing layout
  defmacro layout(layout, attributes) do
    quote do
      Logger.debug("layout2 ++++++++++++++++++++++++++++++++++++++++++++++++++")

      Logger.info("  layout/2 = #{inspect(unquote(layout))}, #{inspect(unquote(attributes))}")
      {id, {width, height}, opts} = WinInfo.get_by_name(unquote(layout))
      Logger.info("  old layout = #{inspect({id, {width, height}, opts})}")

      {new_id, {new_width, new_height}, new_opts} =
        WxLayout.getLayoutAttributes(unquote(attributes))

      Logger.info("  new layout = #{inspect({new_id, {new_width, new_height}, new_opts})}")

      width = replaceIfTrue(width, new_width != nil and new_width != width, new_width)
      height = replaceIfTrue(height, new_height != nil and new_height != height, new_height)

      Logger.info("  after = #{inspect({width, height})}")

      options = [
        {:flag,
         replaceIfTrue(
           opts[:flag],
           new_opts[:flag] != 0 and new_opts[:flag] != opts[:flag],
           new_opts[:flag]
         )}
        | []
      ]

      options = [
        {:border,
         replaceIfTrue(
           opts[:border],
           new_opts[:border] != 0 and new_opts[:border] != opts[:border],
           new_opts[:border]
         )}
        | options
      ]

      options = [
        {:proportion,
         replaceIfTrue(
           opts[:proportion],
           new_opts[:proportion] != 0 and new_opts[:proportion] != opts[:proportion],
           new_opts[:proportion]
         )}
        | options
      ]

      #      # [flags: 2544, border: 1, proportion: 2]
      Logger.info("  options = #{inspect(options)}")
      Logger.info("  new layout = #{inspect({new_id, {width, height}, options})}")

      case new_id do
        :_no_id_ -> :ok
        _ -> put_table({new_id, {width, height}, options})
      end

      Logger.debug("Layout2 ---------------------------------------------------")

      {width, height, options}
    end
  end

  # if condition is true newValue is returned else originalValue
  def replaceIfTrue(originalValue, condition, newValue) do
    if condition do
      newValue
    else
      originalValue
    end
  end

  defmacro border(attributes) do
    quote do
      Logger.debug("border/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      defaults = [size: 1, flags: @wxALL]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      Logger.debug(
        "  :wxSizer.insertSpacer(#{inspect(parent)}, #{inspect(Map.get(opts, :space, 0))})"
      )

      :wxSizer.addSpacer(parent, Map.get(opts, :space, 0))
      :wxSizer.insertSpacer(bs, 9999, 20)
      Logger.debug("border/1 -----------------------------------------------------")
    end
  end

  defmacro spacer(attributes) do
    quote do
      Logger.debug("Spacer/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = {#{inspect(parent)}, #{inspect(container)}, #{inspect(sizer)}}")

      defaults = [space: nil, size: nil, layout: []]
      {id, options, restOpts} = getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      space = options[:space]
      size = options[:size]
      layout = options[:layout]

      case space do
        nil ->
          case size do
            nil ->
              Logger.error("spacer: Either space: or size must be supplied!")

            {w, h} ->
              Logger.debug(
                "  :wxSizer.add(#{inspect(sizer)}, #{inspect(w)}, #{inspect(h)},  #{
                  inspect(layout)
                }}}"
              )

              :wxSizer.add(sizer, w, h, layout)

            other ->
              Logger.error(
                "spacer: Expected {w,h} for the :size parameter, got #{inspect(other)}"
              )
          end

        space ->
          Logger.debug("  :wxSizer.add(#{inspect(sizer)}, #{inspect(space)}}}")
          :wxSizer.addSpacer(sizer, space)
      end

      Logger.debug("Spacer/1 -----------------------------------------------------")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Text controls
  ## ---------------------------------------------------------------------------

  defmacro textControl(attributes) do
    quote do
      Logger.debug("textControl/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

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

      Logger.debug("textControl/1 -----------------------------------------------------")

      # stack_push( sb)
      # unquote(block)
    end
  end

  defmacro staticText(attributes) do
    quote do
      Logger.debug("staticText/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

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
      st = :wxStaticText.new(parent, new_id, Map.get(attrs, :text, "no text"), [])

      case sizer do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(st)}), []")
          :wxBoxSizer.add(sizer, st, [])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(st)}), []")
          :wxStaticBoxSizer.add(sizer, st, [])
      end

      put_table({Map.get(attrs, :id, nil), new_id, st})

      # put_info(Map.get(attrs, :id, :unknown), st)
      # put_xref(new_id, Map.get(attrs, :id, :unknown))

      Logger.debug("staticText/1 -----------------------------------------------------")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Buttons
  ## ---------------------------------------------------------------------------
  defmacro button(attributes, do: block) do
    quote do
      Logger.debug("Button +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      new_id = :wx_misc.newId()

      defaults = [id: :unknown, label: "??", size: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      Logger.debug("  :button.new(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(options)})")

      bt = :wxButton.new(parent, new_id, options)

      stack_push({container, bt, sizer})
      ret = unquote(block)
      stack_pop()

      Logger.debug("  button: ret = #{inspect(ret)}")

      case sizer do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bt)}), []")
          :wxBoxSizer.add(sizer, bt, [{:flag, @wxALL}, {:proportion, 10}])

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bt)}), []")
          :wxStaticBoxSizer.add(sizer, bt, [{:flag, @wxALL}, {:proportion, 10}])

          # xSizer:add(Sizer, ListBox, [{flag, ?wxEXPAND}])
      end

      put_table({id, new_id, bt})

      Logger.debug("Button -----------------------------------------------------")
    end
  end

  defmacro button(attributes) do
    quote do
      Logger.debug("Button/1 +++++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      new_id = :wx_misc.newId()

      defaults = [id: :unknown, label: "??", size: nil, layout: []]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      defaults = [label: "??", size: nil, layout: []]
      attrs = WxUtilities.getObjOpts(unquote(attributes), defaults)
      Logger.debug("  getObjOpts = #{inspect(attrs)}")

      layout = attrs[:layout]
      options = attrs[:options]

      #      {layout, options} =
      #        case List.keytake(options, :layout, 0) do
      #          {{_, layoutName}, options} -> {WxLayout.getLayout(layoutName), options}
      #          nil -> {[], options}
      #        end

      Logger.debug("  :layout = #{inspect(layout)}")

      Logger.debug(
        "  :button.new(#{inspect(container)}, #{inspect(new_id)}, #{inspect(options)})"
      )

      bt = :wxButton.new(parent, new_id, options)

      case sizer do
        {:wx_ref, _, :wxBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bt)}, #{inspect(layout)})")

          # :wxBoxSizer.add(parent, bt, [{:flag, @wxALL}, {:proportion, 10}])
          :wxBoxSizer.add(sizer, bt, layout)

        {:wx_ref, _, :wxStaticBoxSizer, _} ->
          Logger.debug("  :wxBoxSizer.add(#{inspect(sizer)}, #{inspect(bt)}, #{inspect(layout)})")

          # :wxStaticBoxSizer.add(parent, bt, [{:flag, @wxALL}, {:proportion, 10}])
          :wxStaticBoxSizer.add(sizer, bt, layout)
      end

      put_table({id, new_id, bt})

      Logger.debug("Button/1 -----------------------------------------------------")
    end
  end

  ## ---------------------------------------------------------------------------
  ## Tool Bar
  ## ---------------------------------------------------------------------------
  defmacro toolBar(_attributes, do: block) do
    quote do
      Logger.debug("Tool Bar +++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      Logger.debug("  :wxFrame.createToolBar(#{inspect(parent)})")
      tb = :wxFrame.createToolBar(parent)

      stack_push({container, tb, sizer})
      unquote(block)
      stack_pop()

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
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      defaults = [id: :unknown, bitmap: nil, icon: nil, png: nil]
      {id, options, errors} = WxUtilities.getOptions(unquote(attributes), defaults)

      new_id = :wx_misc.newId()

      path = Path.expand(Path.dirname(__ENV__.file) <> "/../")
      Logger.debug("  path: #{inspect(path)}")

      options =
        Enum.filter(options, fn attr ->
          case attr do
            {:bitmap, fileName} ->
              Logger.debug("  BITMAP")
              fileName = Path.expand(path <> "/" <> fileName)
              bitmap = :wxBitmap.new(fileName)
              t = :wxToolBar.addTool(parent, new_id, bitmap)
              put_table({id, new_id, t})
              false

            {:icon, fileName} ->
              fileName = Path.expand(path <> "/" <> fileName)
              Logger.debug("  :wxIcon.new(#{inspect(fileName)}, [{:type, @wxBITMAP_TYPE_ICO}])")
              icon = :wxIcon.new(fileName, [{:type, @wxBITMAP_TYPE_ICO}])
              Logger.debug("  :wxBitmap.new()")
              bitmap = :wxBitmap.new()
              Logger.debug("  :wxBitmap.copyFromIcon(#{inspect(bitmap)}, #{inspect(icon)})")
              :wxBitmap.copyFromIcon(bitmap, icon)

              Logger.debug(
                "  :wxToolBar.addTool(#{inspect(parent)}, #{inspect(new_id)}, #{inspect(bitmap)})"
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
              Logger.debug("  invalid attribute")
              false
          end
        end)

      Logger.debug("  Tool ---------------------------------------------------")
    end
  end

  @doc """
  Add a status bar to the enclosing frame.

  | attributes | Description                                                  | Value     | Default                |
  | ---------- | ------------------------------------------------------------ | --------- | ---------------------- |
  | number     | The number of fields to create. Specify a value greater than 1 to create a multi-field status bar.| atom()    | modulename             |
  | style       | The status bar style.                                       | integer() | 1             |
  | text     | The initial status bar text                                    | string()
                                                                                list of strings        | []                     |

  Example:

  ```
  statusBar(title: "ElixirWx Menu Test")
  ```
  """
  defmacro statusBar(attributes) do
    quote do
      Logger.debug("Status Bar +++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      {id, new_id, sb} = WxStatusBar.new(parent, unquote(attributes))

      put_table({id, new_id, sb})

      Logger.debug("Status Bar -------------------------------------------------")
    end
  end

  ## ----------------------------------------------------------------------------
  defmacro menuBar(do: block) do
    quote do
      Logger.debug("Menu Bar +++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      mb = :wxMenuBar.new()
      Logger.debug("  :wxMenuBar.new() => #{inspect(mb)}")

      stack_push({container, mb, sizer})
      unquote(block)
      stack_pop()

      ret = :wxFrame.setMenuBar(parent, mb)
      Logger.debug("  :wxFrame.setMenuBar(#{inspect(parent)}, #{inspect(mb)}) => #{inspect(ret)}")

      Logger.debug("Menu Bar ---------------------------------------------------")
    end
  end

  ## ===========================================================================
  defmacro menu(attributes, do: block) do
    quote do
      Logger.debug("  Menu +++++++++++++++++++++++++++++++++++++++++++++++++++++++")
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      opts = get_opts_map(unquote(attributes))

      mnu = :wxMenu.new()
      Logger.debug("  :wxMenu.new() => #{inspect(mnu)}")

      t = Map.get(opts, :text, "&????")

      stack_push({container, mnu, sizer})
      unquote(block)
      stack_pop()

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
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

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
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      new_id = :wx_misc.newId()

      Logger.debug("    New Menu Separator")

      :wxMenu.appendSeparator(parent)

      # put_info(Map.get(opts, :id, :unknown), mi)
      # put_xref(new_id, Map.get(opts, :id, :unknown))

      Logger.debug("    Menu Separator  ----------------------------------------")
    end
  end

  def setEvents(events) do
    Logger.debug("setEvents ++++++++++++++++++++++++++++++++++++++++++++++++++")
    setEvents(events, WinInfo.get_by_name(:__main_frame__))
    Logger.debug("setEvents  --------------------------------------------------")
  end

  def setEvents([], _) do
    :ok
  end

  def setEvents([event | events], parent) do
    Logger.info("  setEvents: #{inspect(event)}")

    case event do
      {:timeout, _func} ->
        :ok

      {evt, nil} ->
        options = [userData: __ENV__.module]
        :wxEvtHandler.connect(parent, evt, options)

      {evt, _callback} ->
        options = [userData: __ENV__.module]
        :wxEvtHandler.connect(parent, evt, options)
        # {evt, callback, options} -> options = [{userData: window} | options]
        #                        :wxEvtHandler.connect(parent, evt, options)
    end

    setEvents(events, parent)
  end

  defmacro event(eventType) do
    quote do
      Logger.debug("Event ++++++++++++++++++++++++++++++++++++++++++++++++++")

      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")

      # Logger.debug("  :wxEvtHandler.connect(#{inspect(parent)}, #{inspect(unquote(eventType))})")
      new_id = :wx_misc.newId()

      options = [
        # id: new_id,
        userData: __ENV__.module
      ]

      :wxEvtHandler.connect(container, unquote(eventType), options)

      Logger.debug(
        "  :wxEvtHandler.connect(#{inspect(container)}, #{inspect(unquote(eventType))}, #{
          inspect(options)
        }"
      )

      put_table({unquote(eventType), new_id, nil})
      Logger.debug("Event  --------------------------------------------------")
    end
  end

  defmacro event(eventType, callBack) do
    quote do
      Logger.debug("Event ++++++++++++++++++++++++++++++++++++++++++++++++++")

      # put_table({Map.get(opts, :id, :unknown), new_id, mi})
      put_info(var!(info, Dsl), unquote(eventType), unquote(callBack))

      # WinInfo.get_by_name( name)

      # put_info(eventType, callBack)
      # Agent.update(state, &Map.put(&1, unquote(eventType), unquote(callBack)))
      {container, parent, sizer} = stack_tos()
      Logger.debug("  tos = #{inspect(container)}, #{inspect(parent)}, #{inspect(sizer)}}")
      new_id = :wx_misc.newId()

      options = [
        # id: new_id,
        callback: &WxFunctions.eventCallback/2,
        userData: __ENV__.module
      ]

      :wxEvtHandler.connect(container, unquote(eventType), options)

      put_table({unquote(eventType), new_id, unquote(callBack)})
      Logger.debug("Event  --------------------------------------------------")
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
end
