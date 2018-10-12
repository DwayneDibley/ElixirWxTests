defmodule WxEvents do
  require Logger
  import WxFunctions

  @moduledoc """
  This module implements the window event handling.
  """

  @doc """
  Called after a window has been built, to wait for events from that window and
  dispatch them.
  """
  def windowEventLoop(window) do
    Logger.info(" windowEventLoop(#{inspect(window)})")
    events = WinInfo.get_events(window)
    Logger.info("events = #{inspect(events)}")
    timeout = events[:timeout][:delay]
    Logger.info("timeout = #{inspect(timeout)}")

    timeout =
      case is_number(timeout) do
        false -> nil
        true -> timeout
      end

    windowEventLoop(window, events, timeout)
  end

  @doc """
  Loop here waiting for an event or a timeout....
  """
  defp windowEventLoop(window, events, nil) do
    Logger.info("windowEventLoop = #{inspect(window)}, #{inspect(events)}")
    Logger.info("PID = #{inspect(self())}")

    ret =
      receive do
        # {:wx, 111, {:wx_ref, 35, :wxFrame, []}, [], {:wxCommand, :command_menu_selected, [], -1, 0}}
        {_, id, _, _, {eventGroup, event, data, _, _}} ->
          # Logger.info("windowEventLoop 1")
          name = WinInfo.get_object_name(window, id)
          ret = dispatchEvent(window, {eventGroup, event, name, data}, events)
          # Logger.info("windowEventLoop 1 ret = #{inspect(ret)}")

          case ret do
            :closeWindow ->
              WxFunctions.closeWindow(window)
              :ok

            # Logger.info("Dispatch event returned = #{inspect(ret)}")
            _ ->
              # Logger.info("windowEventLoop 1")
              :ok
          end

          windowEventLoop(window, events, nil)

        # Event send when window is closed causing the event loop to exit.
        {WindowExit, TestWindow} ->
          # Logger.info("windowEventLoop 2")

          {WindowExit, TestWindow}

        {_, _, _, _, {:wxClose, :close_window}} ->
          WxFunctions.closeWindow(window)
          :ok

        event ->
          # test
          # Logger.info("windowEventLoop 3a")

          Logger.debug("windowEventLoop/1 unexpected event Message: #{inspect(event)}")
          windowEventLoop(window, events, nil)
      end
  end

  defp windowEventLoop(window, events, timeout) do
    Logger.info("windowEventLoop = #{inspect(window)}, #{inspect(events)}, #{inspect(timeout)}")
    Logger.info("PID = #{inspect(self())}")

    ret =
      receive do
        {_, id, _, _, {eventGroup, event, data, 0, 0}} ->
          # Logger.info("windowEventLoop 1")
          name = WinInfo.get_object_name(window, id)
          ret = dispatchEvent(window, {eventGroup, event, name, data}, events)
          # Logger.info("windowEventLoop 1 ret = #{inspect(ret)}")

          case ret do
            :closeWindow ->
              # WxFunctions.closeWindow(window)
              :ok

            # Logger.info("Dispatch event returned = #{inspect(ret)}")
            _ ->
              # Logger.info("windowEventLoop 1")
              :ok
          end

          windowEventLoop(window, events, timeout)

        # Event send when window is closed causing the event loop to exit.
        {WindowExit, TestWindow} ->
          # Logger.info("windowEventLoop 2")

          {WindowExit, TestWindow}

        event ->
          # test
          # Logger.info("windowEventLoop 3a")

          # Logger.debug("windowEventLoop/1 unexpected event Message: #{inspect(event)}")
          windowEventLoop(window, events, timeout)
      after
        timeout ->
          Logger.info("windowEventLoop 4")
          ret = dispatchTimeout(window, events)
          # Logger.info("Timeout  Handler returned = #{inspect(ret)}")

          timeout =
            case is_number(ret) do
              false -> timeout
              true -> ret
            end

          windowEventLoop(window, events, timeout)
      end
  end

  @doc """
  An event arrived, so find and invoke the handler
  """
  defp dispatchEvent(window, {eventGroup, event, id, data}, events) do
    # Logger.info(
    #  "dispatchEvent(#{inspect(eventGroup)}, #{inspect(event)}, #{inspect(id)}, #{inspect(data)})"
    # )

    eventInfo = events[event]
    # Logger.info("eventInfo = #{inspect(eventInfo)}")

    # TestWindow, :command_button_clicked, :menu_test, _senderObj
    ret = eventInfo[:handler].(window, event, id, nil)
    # Logger.info("Handler returned = #{inspect(ret)}")
    ret
  end

  defp dispatchTimeout(window, events) do
    # Logger.info("dispatchTimeout(#{inspect(window)})")

    eventInfo = events[:timeout]
    # Logger.info("eventInfo = #{inspect(eventInfo)}")

    # TestWindow, :command_button_clicked, :menu_test, _senderObj
    ret = eventInfo[:handler].(window, nil, nil, nil)
    # Logger.info("Handler returned = #{inspect(ret)}")
    ret
  end

  @doc """
  Called by the events macro to connect the events and put them into window info.
  """
  def setEvents(_, _, []) do
    :ok
  end

  def setEvents(window, parent, [event | events]) do
    # Logger.debug("setEvents: #{inspect(event)}")
    setEvent(window, parent, event)
    setEvents(window, parent, events)
  end

  defp setEvent(window, parent, {:timeout, options}) do
    # Logger.debug("Timeout event...")
    WinInfo.put_event(window, :timeout, options)
  end

  defp setEvent(window, parent, {eventType, options}) do
    # events = WinInfo.get_events(window)

    # Logger.debug(
    #  ":wxEvtHandler.connect(#{inspect(parent)}, #{inspect(eventType)}, #{inspect(options)})"
    # )

    # :wxEvtHandler.connect(parent, eventType, options)
    :wxEvtHandler.connect(parent, eventType)
    WinInfo.put_event(window, eventType, options)
  end
end
