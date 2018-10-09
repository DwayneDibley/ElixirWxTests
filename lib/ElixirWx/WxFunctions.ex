defmodule WxFunctions do
  require Logger

  import WxUtilities
  @moduledoc """
  ```
  ## Functions used by the DSL.
  """


  # ============================================================================
  # Top level operations
  # ============================================================================
  @doc """
  Cause the window to be shown on the screen
  """
  def showWindow(spec) do
    mainFrame = spec[:main_frame]
    :wxWindow.show(mainFrame)
  end

  def hideWindow(spec) do
    mainFrame = spec[:main_frame]
    :wxWindow.show(mainFrame, false)
  end

  @doc """
  Destroy the window,
  """
  def closeWindow({windowData, _xrefData}) do
    Logger.debug("closeWindow(#{inspect(windowData)})")
    frame = Map.get(windowData, :__main_frame__, nil)
    case frame do
    nil ->  Logger.error("No __main_frame__!!")
    _   ->
    Logger.debug(":wxEvtHandler.disconnect(#{inspect(frame)})")
    :wxEvtHandler.disconnect(frame)
    Logger.debug(":wxEvtHandler.destroy(#{inspect(frame)})")
    :wxWindow.destroy(frame)
  end
  end

  # ------------------------------------------------------------------------------------
  def setFrameIcon(frame, iconFile) do
    # :wxFrame.setIcon(frame, iconFile)
    icon = :wxIcon.new(iconFile)
    :wxTopLevelWindow.setIcon(frame, icon)
  end

  # ============================================================================
  # Even handling operations
  # ============================================================================
  def eventCallback({:wx, id, eventSource, {windowData, xrefData}, eventData}, event) do
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

    fx = Map.get(windowData, event, nil)

    fx.(event, {xrefData[id], eventSource}, {windowData, xrefData})
  end

  # Called when the application wants to check for an event. It is only
  # necessary to call this function if no event handler was specified in
  # the event specification
  def getEvent(timeout \\ 0) do
    receive do
      {:wx, senderId, senderObj, {info, xref}, {group, event, _, _, _}} ->
        Logger.debug("Event Message: #{inspect(senderId)}, #{inspect(senderObj)}}")
        Logger.debug("  Event: #{inspect(event)}")

        #Logger.debug("  Info: #{inspect(info)}")
        #Logger.debug("  Xref: #{inspect(xref)}")

        sender = Map.get(xref, senderId, senderId)
        {sender, event, group}

        {:wx, senderId, senderObj, {info, xref}, {group, event}} ->
          Logger.debug("Event Message: #{inspect(senderId)}, #{inspect(senderObj)}}")
          Logger.debug("  Event: #{inspect(event)}")

          #Logger.debug("  Info: #{inspect(info)}")
          #Logger.debug("  Xref: #{inspect(xref)}")

          sender = Map.get(xref, senderId, senderId)
          {sender, event, group}

      other ->
        Logger.debug("Unhandled event Message: #{inspect(other)}")
        other
    after
      timeout * 1000 ->
        :timeout
    end
  end

  # Object independent text interface
  def getObjText(ctrlId, {info, xref}) do
    ctrl = Map.get(info, ctrlId)

    case ctrl do
      {_, _, :wxTextCtrl, _} -> to_string(:wxTextCtrl.getValue(ctrl))
    end
  end

  def putObjText(ctrlId, text, {info, xref}) do
    ctrl = Map.get(info, ctrlId)

    case ctrl do
      {_, _, :wxStaticText, _} -> :wxStaticText.setLabel(ctrl, text)
    end
  end
end
