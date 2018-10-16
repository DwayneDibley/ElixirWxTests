defmodule TestCode do
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

    # parent = proplists:get_value(parent, Config),
    frame = :wxFrame.new(wx, :wx_misc.newId(), [])

    panel = :wxPanel.new(frame, [])

    #   Setup sizers
    mainSizer = :wxBoxSizer.new(@wxVERTICAL)
    sizer = :wxStaticBoxSizer.new(@wxVERTICAL, panel, [{:label, "wxSizer"}])

    choices = [
      "Vertical Example",
      "Horizontal Example",
      "Add A Strechable",
      "More Than One Strechable",
      "Weighting Factor",
      "Edge Affinity",
      "Spacer",
      "Centering In Avalible Space",
      "Simple border",
      "East And West border",
      "North And South border",
      "Box In Box",
      "Boxes Inside A border",
      "border In A Box",
      "Simple Grid",
      "More Grid Features",
      "Flexible Grid",
      "Grid With Alignment",
      "Proportional Resize With Alignments"
    ]

    listBox = :wxListBox.new(panel, @wxID_ANY, [{:choices, choices}])
    #   wxListBox:connect(ListBox, command_listbox_doubleclicked),

    #  Add to sizers
    :wxSizer.add(sizer, listBox, [{:flag, @wxEXPAND}])
    :wxSizer.add(mainSizer, sizer, [{:flag, @wxEXPAND}, {:proportion, 1}])

    :wxPanel.setSizer(panel, mainSizer)
    #   {Panel, #state{parent=Panel, config=Config}}.

    :wxFrame.show(frame)

    createExample(panel, "vertical", &vertical/1)
    # createExample(panel, "horizontal", &horizontal/1)
    # createExample(panel, "Add a strechable", &add_a_strechable/1)
    # createExample(panel, "More than one strechable", &more_than_one_strechable/1)
    # createExample(panel, "Weighting Factor", &weighting_factor/1)
    #  createExample(panel, "Edge Affinity", &edge_affinity/1)
    # createExample(panel, "Spacer", &spacer/1)
    # createExample(panel, "Centering in availabl space", &centering_in_avalible_space/1)
    # createExample(panel, "Simple border", &simple_border/1)
    # createExample(panel, "East and West border", &east_and_west_border/1)
    # createExample(panel, "North and South border", &north_and_south_border/1)
    # createExample(panel, "Box in Box", &box_in_box/1)
    # createExample(panel, "Boxes inside a border", &boxes_inside_a_border/1)
    # createExample(panel, "border in a box", &border_in_a_box/1)
    # createExample(panel, "Simple Grid", &simple_grid/1)
    # createExample(panel, "More Grid Features", &more_grid_features/1)
    # createExample(panel, "Flexible Grid", &flexible_grid/1)
    # createExample(panel, "Grid with alignment", &grid_with_alignment/1)

    createExample(
      panel,
      "Proportional resize with alignments",
      &proportional_resize_with_alignments/1
    )

    receive do
    after
      30000 -> nil
    end
  end

  def createExample(parent, example, builder) do
    frame =
      :wxFrame.new(parent, @wxID_ANY, example, [
        {:style, @wxDEFAULT_FRAME_STYLE ||| @wxFRAME_FLOAT_ON_PARENT}
      ])

    :wxFrame.center(frame)
    panel = :wxPanel.new(frame, [])

    sizer = builder.(panel)

    :wxPanel.setSizer(panel, sizer)
    :wxSizer.fit(sizer, panel)
    :wxFrame.createStatusBar(frame)
    :wxFrame.setStatusText(frame, "Resize window to see how the sizers respond..")
    :wxFrame.fit(frame)
    :wxFrame.show(frame)
  end

  def create_box(parent) do
    win = :wxWindow.new(parent, @wxID_ANY, [{:style, @wxBORDER_SIMPLE}, {:size, {50, 25}}])
    :wxWindow.setBackgroundColour(win, wxWHITE())
    win
  end

  def vertical(parent) do
    sizer = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    sizer
  end

  def horizontal(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    sizer
  end

  def add_a_strechable(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    sizer
  end

  def more_than_one_strechable(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    sizer
  end

  def weighting_factor(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 3}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    sizer
  end

  def edge_affinity(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxALIGN_TOP}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxALIGN_CENTER}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxALIGN_BOTTOM}])
    sizer
  end

  def spacer(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, 60, 20, [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    sizer
  end

  def centering_in_avalible_space(parent) do
    sizer = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, 0, 0, [{:proportion, 1}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxALIGN_CENTER}])
    :wxSizer.add(sizer, 0, 0, [{:proportion, 1}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    sizer
  end

  def simple_border(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    win = create_box(parent)
    :wxWindow.setSize(win, 80, 80)
    :wxSizer.add(sizer, win, [{:proportion, 1}, {:flag, @wxEXPAND ||| @wxALL}, {:border, 15}])
    sizer
  end

  def east_and_west_border(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    win = create_box(parent)
    :wxWindow.setSize(win, 80, 80)

    :wxSizer.add(sizer, win, [
      {:proportion, 1},
      {:flag, @wxEXPAND ||| @wxEAST ||| @wxWEST},
      {:border, 15}
    ])

    sizer
  end

  def north_and_south_border(parent) do
    sizer = :wxBoxSizer.new(@wxHORIZONTAL)
    win = create_box(parent)
    :wxWindow.setSize(win, 80, 80)

    :wxSizer.add(sizer, win, [
      {:proportion, 1},
      {:flag, @wxEXPAND ||| @wxNORTH ||| @wxSOUTH},
      {:border, 15}
    ])

    sizer
  end

  def box_in_box(parent) do
    sizer = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    sizer2 = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    sizer3 = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 2}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])

    :wxSizer.add(sizer2, sizer3, [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, sizer2, [{:proportion, 1}, {:flag, @wxEXPAND}])

    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    sizer
  end

  def boxes_inside_a_border(parent) do
    border = :wxBoxSizer.new(@wxHORIZONTAL)
    sizer = add_a_strechable(parent)
    :wxSizer.add(border, sizer, [{:proportion, 1}, {:flag, @wxEXPAND ||| @wxALL}, {:border, 15}])
    border
  end

  def border_in_a_box(parent) do
    insideBox = :wxBoxSizer.new(@wxHORIZONTAL)

    sizer2 = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    :wxSizer.add(insideBox, sizer2, [{:proportion, 0}, {:flag, @wxEXPAND}])

    border = :wxBoxSizer.new(@wxHORIZONTAL)
    :wxSizer.add(border, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND ||| @wxALL}])

    :wxSizer.add(insideBox, border, [
      {:proportion, 1},
      {:flag, @wxEXPAND ||| @wxALL},
      {:border, 20}
    ])

    sizer3 = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 2}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer3, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])

    :wxSizer.add(insideBox, sizer3, [{:proportion, 1}, {:flag, @wxEXPAND}])

    outsideBox = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(outsideBox, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(outsideBox, insideBox, [{:proportion, 1}, {:flag, @wxEXPAND}])
    :wxSizer.add(outsideBox, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    outsideBox
  end

  def simple_grid(parent) do
    # rows, cols, vgap, hgap
    gridSizer = :wxGridSizer.new(3, 3, 2, 2)

    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    gridSizer
  end

  def more_grid_features(parent) do
    # rows, cols, vgap, hgap
    gridSizer = :wxGridSizer.new(3, 3, 1, 1)

    sizer = :wxBoxSizer.new(@wxVERTICAL)
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(sizer, create_box(parent), [{:proportion, 1}, {:flag, @wxEXPAND}])

    gridSizer2 = :wxGridSizer.new(2, 2, 4, 4)
    :wxSizer.add(gridSizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer2, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_RIGHT ||| @wxALIGN_BOTTOM}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_LEFT ||| @wxALIGN_BOTTOM}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxALIGN_CENTER}])

    :wxSizer.add(gridSizer, sizer, [
      {:proportion, 0},
      {:flag, @wxEXPAND ||| @wxALL},
      {:border, 10}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    :wxSizer.add(gridSizer, gridSizer2, [
      {:proportion, 0},
      {:flag, @wxEXPAND ||| @wxALL},
      {:border, 4}
    ])

    gridSizer
  end

  def flexible_grid(parent) do
    # rows, cols, vgap, hgap
    flexGridSizer = :wxFlexGridSizer.new(3, 3, 2, 2)
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, 175, 50, [])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])
    :wxSizer.add(flexGridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxEXPAND}])

    :wxFlexGridSizer.addGrowableRow(flexGridSizer, 0)
    :wxFlexGridSizer.addGrowableRow(flexGridSizer, 2)
    :wxFlexGridSizer.addGrowableCol(flexGridSizer, 1)
    flexGridSizer
  end

  def grid_with_alignment(parent) do
    # rows, cols, vgap, hgap
    gridSizer = :wxGridSizer.new(3, 3, 2, 2)

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_TOP ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_TOP ||| @wxALIGN_CENTER_HORIZONTAL}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_TOP ||| @wxALIGN_RIGHT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_CENTER_VERTICAL ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [{:proportion, 0}, {:flag, @wxALIGN_CENTER}])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_CENTER_VERTICAL ||| @wxALIGN_RIGHT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_BOTTOM ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_BOTTOM ||| @wxALIGN_CENTER_HORIZONTAL}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxALIGN_BOTTOM ||| @wxALIGN_RIGHT}
    ])

    gridSizer
  end

  def proportional_resize_with_alignments(parent) do
    # rows, cols, vgap, hgap
    gridSizer = :wxGridSizer.new(3, 3, 2, 2)

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_TOP ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_TOP ||| @wxALIGN_CENTER_HORIZONTAL}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_TOP ||| @wxALIGN_RIGHT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_CENTER_VERTICAL ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_CENTER}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_CENTER_VERTICAL ||| @wxALIGN_RIGHT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_BOTTOM ||| @wxALIGN_LEFT}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_BOTTOM ||| @wxALIGN_CENTER_HORIZONTAL}
    ])

    :wxSizer.add(gridSizer, create_box(parent), [
      {:proportion, 0},
      {:flag, @wxSHAPED ||| @wxALIGN_BOTTOM ||| @wxALIGN_RIGHT}
    ])

    gridSizer
  end
end
