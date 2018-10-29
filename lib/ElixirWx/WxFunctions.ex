defmodule WxFunctions do
  require Logger
  # import WxUtilities

  @moduledoc """
  ```
  ## General functions
  newWindow({window_spec, evt_handler}, show)
  newWindow(name, {window_spec, evt_handler}, show)
  """

  # @doc """
  # Create a new window where:
  # windiw_spec: Ths file containing the window specification
  # evt_handler: The file containing the code to be called on window _eventSource
  # show: Bool, if true the window will be shown, if false, the window must be
  #             shown by calling showWindow separately
  # """
  # def newWindow({window_spec, evt_handler}, show) do
  #   case WxWindowObject.start_link({nil, {window_spec, evt_handler}}, show) do
  #     {:ok, window} ->
  #       {:ok, window}
  #
  #     {:error, reason} ->
  #       Logger.error("Cannot create window> #{inspect(reason)}")
  #       :err
  #   end
  # end
  #
  # @doc """
  # Create a new named window where:
  # name:  An atom used to name the window
  # windiw_spec: Ths file containing the window specification
  # evt_handler: The file containing the code to be called on window _eventSource
  # show: Bool, if true the window will be shown, if false, the window must be
  #             shown by calling showWindow separately
  # """
  # def newWindow(name, {window_spec, evt_handler}, show) do
  #   case WxWindowObject.start_link({name, {window_spec, evt_handler}}, show) do
  #     {:ok, window} ->
  #       {:ok, window}
  #
  #     {:error, reason} ->
  #       Logger.error("Cannot create window> #{inspect(reason)}")
  #       :err
  #   end
  # end

  # @doc """
  # Finction called to close and destroy the current window. This may be called from
  # an event callback.
  # """
  # def closeWindow(windowName) do
  #   Logger.debug("closeWindow(#{inspect(windowName)})")
  #   {_, _, frame} = WinInfo.get_by_name(:__main_frame__)
  #
  #   case frame do
  #     nil ->
  #       Logger.error("No __main_frame__!!")
  #
  #     _ ->
  #       :wxEvtHandler.disconnect(frame)
  #       :wxWindow.destroy(frame)
  #   end
  #
  #   send(self(), {WindowExit, windowName})
  # end
  #
  # ------------------------------------------------------------------------------------
  def setFrameIcon(frame, iconFile) do
    # :wxFrame.setIcon(frame, iconFile)
    icon = :wxIcon.new(iconFile)
    :wxTopLevelWindow.setIcon(frame, icon)
  end

  # ============================================================================
  # Event handling operations
  # ============================================================================
  @doc """
  Event handling

  If the event is registered with a callback function, it will be routed to that
  function. A callback function must have arity 3 and accept the following
  parameters:

  callback(window, eventType, senderId, senderObj)
  """
  def eventCallback({:wx, id, _eventSource, windowData, eventData}, event) do
    Logger.debug("eventCallback!!: Event=#{inspect(event)}")
    Logger.debug("eventCallback!!: id=#{inspect(id)}")
    Logger.debug("eventCallback!!: eventData=#{inspect(eventData)}")

    event =
      case eventData do
        {_, event, [], -1, 0} ->
          event

        {:wxCommand, event, [], 0, 0} ->
          event

        {:wxClose, event} ->
          event

        _ ->
          Logger.error("Unknown event received!!: Data=#{inspect(eventData)}")
          :unknown_event
      end

    {eventType, _idx, callBack} = WinInfo.get_by_name(event)
    {senderName, _senderId, senderObj} = WinInfo.get_by_id(id)

    try do
      callBack.(windowData, eventType, senderName, senderObj)
    rescue
      e in RuntimeError -> Logger.error("Callback error: #{inspect(e)}")
    end
  end

  # Called when the application wants to check for an event. It is only
  # necessary to call this function if no event handler was specified in
  # the event specification
  def getEvent(timeout \\ 0) do
    receive do
      {:wx, senderId, senderObj, _winInfo, {_group, event, _, _, _}} ->
        Logger.debug("Event Message: #{inspect(senderId)}, #{inspect(senderObj)}}")
        Logger.debug("  Event: #{inspect(event)}")

        {_eventType, _senderId, _callback} = WinInfo.get_by_id(senderId)

      {:wx, senderId, senderObj, _winInfo, {group, event}} ->
        Logger.debug("Event Message: #{inspect(senderId)}, #{inspect(senderObj)}}")
        Logger.debug("  Event: #{inspect(event)}")

        {_eventType, senderId, _callback} = WinInfo.get_by_id(senderId)
        {senderId, event, group}

      other ->
        Logger.debug("Unhandled event Message: #{inspect(other)}")
        other
    after
      timeout * 1000 ->
        :timeout
    end
  end

  # Object independent text interface
  def getObjText(ctrlId, {info, _xref}) do
    ctrl = Map.get(info, ctrlId)

    case ctrl do
      {_, _, :wxTextCtrl, _} -> to_string(:wxTextCtrl.getValue(ctrl))
    end
  end

  def putObjText(ctrlId, text, {info, _xref}) do
    ctrl = Map.get(info, ctrlId)

    case ctrl do
      {_, _, :wxStaticText, _} -> :wxStaticText.setLabel(ctrl, text)
    end
  end
end
