defmodule WxEvents do

  require Logger

  def windowEventLoop(window) do
    {_, events} = WinInfo.get_events(window)
    Logger.info("events = #{inspect(events)}")
    windowEventLoop(window, events)
  end

    def windowEventLoop(window, events) do
    timeout = 1
    receive do
      {_, id, _, _, {eventGroup, event, data, 0, 0}} ->
        IO.inspect("EVENT 1")
        name = WinInfo.get_object_name(window, id)
        dispatchEvent(window, {eventGroup, event, name, data}, events)
        windowEventLoop(window, events)

        {window, TestWindow} -> :ok
      event ->
        IO.inspect("EVENT 2")
          Logger.debug("windowEventLoop/1 event Message: #{inspect(event)}")
          windowEventLoop(window, events)
    after
      timeout * 1000 ->
        :timeout
        windowEventLoop(window, events)
    end
  end

  def dispatchEvent(window, {eventGroup, event, id, data}, events) do
    Logger.info("dispatchEvent(#{inspect(eventGroup)}, #{inspect(event)}, #{inspect(id)}, #{inspect(data)})")
    eventInfo = events[event]
    Logger.info("eventInfo = #{inspect(eventInfo)}")

    #TestWindow, :command_button_clicked, :menu_test, _senderObj
    ret = eventInfo[:handler].(window, event, id, nil)
    Logger.info("Handler returned = #{inspect(ret)}")
  end

  @doc """
  Called by the events macro to connect the events and put them into window info.
  """
  def setEvents(_, _, []) do
    :ok
  end

  def setEvents(window, parent, [event | events]) do
    Logger.debug("setEvents: #{inspect(event)}")
    setEvent(window, parent, event)
    setEvents(window, parent, events)
  end

  def setEvent(window, parent, {:timeout, options}) do
    Logger.debug("Timeout event...")
  end

  def setEvent(window, parent, {eventType, options}) do
    #events = WinInfo.get_events(window)

    Logger.debug(":wxEvtHandler.connect(#{inspect(parent)}, #{inspect(eventType)}, #{inspect(options)})")
    #:wxEvtHandler.connect(parent, eventType, options)
    :wxEvtHandler.connect(parent, eventType)
    WinInfo.put_event(window, eventType, options)
  end


end
