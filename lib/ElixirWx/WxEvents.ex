defmodule WxEvents do
  require Logger
  # import WxFunctions

  @moduledoc """
  This module implements the window event handling.
  """

  @doc """
  Called after a window has been built, to wait for events from that window and
  dispatch them.
  """
  def windowEventLoop(window) do
    Logger.info(" windowEventLoop(#{inspect(window)})")
    events = WinInfo.get_events()
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

  # loop without timeout
  defp windowEventLoop(window, events, nil) do
    receive do
      event ->
        Logger.info("event: #{inspect(event)}")
        ret = dispatchEvent(window, events, event)

        case ret do
          :closeWindow -> WxFunctions.closeWindow(window)
          _ -> windowEventLoop(window, events, nil)
        end
    end
  end

  # loop with timeout
  defp windowEventLoop(window, events, timeout) do
    receive do
      event ->
        ret = dispatchEvent(window, events, event)

        # Handle return values
        case ret do
          :closeWindow -> WxFunctions.closeWindow(window)
          _ -> windowEventLoop(window, events, nil)
        end
    after
      timeout ->
        ret = dispatchTimeout(window, events)

        # If the timeout handler returns an integer, it is the new timeout value
        timeout =
          case is_number(ret) do
            false -> timeout
            true -> ret
          end

        windowEventLoop(window, events, timeout)
    end
  end

  # An event arrived, so find and invoke the handler
  defp dispatchEvent(
         window,
         events,
         {_, senderId, _senderObj, _, {eventGroup, event, data, _, _}}
       ) do
    sender = WinInfo.get_object_name(senderId)

    Logger.info(
      "dispatchEvent(window, {#{inspect(eventGroup)}, #{inspect(event)}, #{inspect(sender)}, #{
        inspect(data)
      }}, events)"
    )

    # dispatchEvent(window, {eventGroup, event, sender, data}, events)
    eventInfo = events[event]
    eventInfo[:handler].(window, event, sender, nil)
  end

  defp dispatchEvent(_window, _events, {_, _, _, _, {:wxClose, :close_window}}) do
    :closeWindow
  end

  defp dispatchEvent(_window, _events, event) do
    Logger.info("Unexpected event: #{inspect(event)}")
    # name = WinInfo.get_object_name(id)
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

  # ----------------------------------------------------------------------------
  @doc """
  Called by the events macro to connect the events and put them into window info.
  """
  def setEvents(_, _, []) do
    :ok
  end

  def setEvents(window, parent, [event | events]) do
    setEvent(window, parent, event)
    setEvents(window, parent, events)
  end

  defp setEvent(_window, _parent, {:timeout, options}) do
    WinInfo.put_event(:timeout, options)
  end

  defp setEvent(_window, parent, {eventType, options}) do
    Logger.debug(":wxEvtHandler.connect(#{inspect(parent)}, #{inspect(eventType)})")
    :wxEvtHandler.connect(parent, eventType)
    WinInfo.put_event(eventType, options)
  end
end
