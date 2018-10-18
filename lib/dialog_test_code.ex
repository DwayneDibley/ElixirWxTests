defmodule DialogTestCode do
  import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  ```
  A demo of wxWindows menu's.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """
  def run() do
    wx = :wx.new()

    parent = :wxFrame.new(wx, :wx_misc.newId(), [])

    panel = :wxScrolledWindow.new(parent, [])
    :wxScrolledWindow.setScrollRate(panel, 5, 5)

    # Setup sizers
    mainsizer = :wxBoxsizer.new(@wxVERTICAL)
    sizer = :wxStaticBoxsizer.new(@wxVERTICAL, panel, [{:label, "Dialogs"}])

    buttons = [
      :wxButton.new(panel, 1, [{:label, "wxDirDialog"}]),
      :wxButton.new(panel, 2, [{:label, "wxFileDialog"}]),
      :wxButton.new(panel, 3, [{:label, "wxColourDialog"}]),
      :wxButton.new(panel, 4, [{:label, "wxMessageDialog"}]),
      :wxButton.new(panel, 5, [{:label, "wxTextEntryDialog"}]),
      :wxButton.new(panel, 6, [{:label, "wxSingleChoiceDialog"}]),
      :wxButton.new(panel, 7, [{:label, "wxMultiChoiceDialog"}]),
      :wxButton.new(panel, 10, [{:label, "wxFontDialog"}])
    ]

    choices = [
      "Orange",
      "Banana",
      "Apple",
      "Lemon",
      "Pear",
      "Carrot",
      "Potato",
      "Peach",
      "Tomato",
      "Grape",
      "Pineapple",
      "Blueberry"
    ]

    #    dialogs = [{wxDirDialog, [:panel, []]},
    # 	       {wxFileDialog, [:panel, []]},
    # 	       {wxColourDialog, [:panel, []]},
    # 	       {wxSingleChoiceDialog, [:panel, "wxSingleChoiceDialog\n"
    # 				       "Feel free to pick one of "
    # 				       "these items !", "Caption",
    # 				       choices]},
    # 	       {wxMultiChoiceDialog, [:panel, "wxMultiChoiceDialog\n"
    # 				      "Feel free to pick one of "
    # 				      "these items !", "Caption",
    # 				      choices]},
    # 	       {wxMessageDialog, [:panel, "This is a wxMessageDialog !"]},
    # 	       {wxTextEntryDialog, [:panel, "This is a wxTextEntryDialog !",
    # 				    [{:value, "Erlang is the best !"}]]},
    # 	       {wxFontDialog, [get_parent(parent), :wxFontData.new()]}]

    # Add to sizers
    # fun = fun(Button) ->
    #   Label = list_to_atom(wxButton:getLabel(Button)),
    #   wxSizer:add(Sizer, Button, [{border, 4}, {flag, ?wxALL bor ?wxEXPAND}]),
    #   wxButton:connect(Button, command_button_clicked, [{userData, Label}])
    # end,
    # :wx.foreach(fun, buttons),

    # :wxSizer.add(mainSizer, sizer)

    # :wxPanel.setSizer(panel, mainSizer)
    # {panel, #state{parent=Panel, config=Config,
    #    dialogs = dialogs, choices = choices}}.
  end
end
