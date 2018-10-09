defmodule WxMessageDialog do
  require Logger
  use WxDefines

  @moduledoc """
  ## Create and optionally show a wxMxmessageDialog dialog pop-up window.
  Parameters:
    parent: The parent window or nil.
    message: The message to display in the dialog.
    options:
      caption: text   Bold text to be displayed above the message.
      style:          @wxYES_NO, Yes and no buttons.
                      @wxCANCEL, Ok and Cancel buttons
      pos:            Has no effect.

  returns:
      If showing modally, returns the button that was clicked as an atom
      (:ok, :no or :cancel) else the dialog object is returned.
  """
  def create(parent, message \\ "", options \\ []) do

    parent =
      case parent do
        nil -> :wx.null()
        _ -> parent
      end

    {options, errors} = getOptList(options, [:caption, :style, :pos, :show, :modal, :size])

    modal =
      case(options[:modal]) do
        false -> false
        _ -> true
      end

    show =
      case(options[:show]) do
        false -> false
        _ -> true
      end

    options = List.keydelete(options, :show, 0)
    options = List.keydelete(options, :modal, 0)

    if length(errors) != 0,
      do: Logger.warn("WxMessageDialog.new() invalid option(s): #{inspect(errors)}")

    md = :wxMessageDialog.new(parent, message, options)

    ret =
      case {show, modal} do
        {false, _} ->
          md

        {true, true} ->
          ret = :wxMessageDialog.showModal(md)
          :wxMessageDialog.destroy(md)
          ret

        {true, false} ->
          ret = :wxMessageDialog.show(md)
          Logger.debug("show non Modal returned: #{inspect(ret)}")
          md
      end

    case ret do
      @wxID_OK -> :ok
      @wxID_CANCEL -> :cancel
      @wxID_YES -> :yes
      @wxID_NO -> :no
      _ -> ret
    end
  end

  def show(dialog, modal \\ true) do
    case modal do
      true ->
        :wxMessageDialog.showModal(dialog)

      false ->
        :wxMessageDialog.show(dialog)
    end
  end

  def destroy(dialog) do
    :wxMessageDialog.destroy(dialog)
  end

  # Get a list of options checking they are in the allowed opts list
  def getOptList(options, allowedOpts) do
    getOptList(options, [], allowedOpts)
  end

  def getOptList(options, optList, []) do
    {optList, options}
  end

  def getOptList(options, optList, [h | t]) do
    optList =
      case options[h] do
        nil -> optList
        val -> [{h, val} | optList]
      end

    getOptList(List.keydelete(options, h, 0), optList, t)
  end
end
