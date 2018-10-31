# ElixirWxTests

_Tests for the ElixirWx package._

The tests can be invoked directly in iex using:

```
  iex -S mix
```

or compiled and run as an escript:

```
mix esctript.build
./wx_tests
```

On start, the main test window is shown. The various tests are chosen from this
windows menu. Note that on MacOs the menu is at the top of the main window!

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Main_test_window.png "Main test window.")

## Simple Tests

### Simple -> Frame

This tests some of the funtionality of a wxBoxSizer. The two words should be
arranged horizontally.

Code:

```
def createWindow(show) do
    mainWindow name: :simple_frame_window, show: show, setFocus: true do
      # Create a simple frame.
      frame id: :main_frame,
            title: "Simple frame",
            size: {320, 150},
            pos: {300, 250} do
      end

      events(close_window: [])
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Simple_Frame.png "Simple Frame window.")

### Simple -> Tool Bar

This tests some of the funtionality of a tool bar.

Code:

```
def createWindow(show) do
    mainWindow name: :tool_bar_window, show: show do
      frame id: :main_frame,
            title: "Tool Bar Test",
            size: {350, 250},
            pos: {200, 250} do
        toolBar(style: @wxTB_HORIZONTAL || @wxNO_BORDER) do
          tool(id: :tb_new, icon: "../images/icons/stock_new.ico")
          tool(id: :tb_open, icon: "../images/icons/stock_open.ico")
          tool(id: :tb_undo, icon: "../images/icons/stock_undo.ico")
          tool(id: :tb_redo, icon: "../images/icons/stock_redo.ico")
          tool(id: :tb_save, icon: "../images/icons/stock_save.ico")
        end

        statusBar(text: "ElixirWx Tool Bar test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Simple_tool_bar.png "Simple Frame window.")


## Sizer Tests

### Sizers -> Box Sizer

This tests some of the funtionality of a wxBoxSizer. The two words should be
arranged horizontally.

Code:

```
  def createWindow(show) do
    mainWindow name: :box_sizer_window, show: show do
      frame id: :main_frame,
            title: "Box Sizers Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            staticText(text: "hello")
            staticText(text: "world")
          end
        end
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Box_sizer.png "Box Sizer window.")

### Sizers -> Static Box Sizer

This tests some of the funtionality of a wxStaticBoxSizer. The three buttons should be arranged vertically.

Code:

```
  def createWindow(show) do
    mainWindow name: :static_box_sizer_window, show: show do
      frame id: :main_frame,
            title: "Static Box Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            staticBoxSizer id: :inner_sizer, 
                           orient: @wxVERTICAL, 
                           label: "Static Box Sizer Label" do
              button(id: :button1, label: "&Button 1")
              button(id: :button2, label: "&Button 2")
              button(id: :button3, label: "&Button 3")
            end
          end
        end
        statusBar(text: "ElixirWx Static Box Sizer test")
      end
      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Staic_box_sizer.png "Box Sizer window.")

### Sizers -> Vertical  Sizer

Uses a box sizer to arrange 4 windows with coloured backgrounds vertically.

Code:

```
  def createWindow(show) do
    mainWindow name: :bvertical_sizer_window, show: show do
      frame id: :vert_sz_frame,
            title: "Vertical Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxVERTICAL do
            layout1 = [proportion: 0, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Vertical Sizer test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Vertical_sizer.png "Vertical Sizer window.")

### Sizers -> Horizontal Sizer

Uses a box sizer to arrange 4 windows with coloured backgrounds horizontally.

Code:

```
  def createWindow(show) do
    mainWindow name: :horizontal_sizer_window, show: show do
      frame id: :vert_sz_frame,
            title: "Horizontal Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            layout1 = [proportion: 0, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Horizontal Sizer test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Horizontal_sizer.png "Vertical Sizer window.")

### Sizers -> Stretchable Sizer

Uses a box sizer to arrange 4 windows with coloured backgrounds horizontally. When the main window is resized, all stay the same width except for the last, which stretches in proportion with the window.

Code:

```
def createWindow(show) do
    mainWindow name: :stretchable_sizer_window, show: show do
      frame id: :str_sz_frame,
            title: "Stretchable Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Stretchable Sizer test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Stretchable_sizer.png "Stretchable Sizer window.")

### Sizers -> Stretchable Sizers

Uses a box sizer to arrange 6 windows with coloured backgrounds layed out horizontally. When the main window is resized, two stay the same width, and the rightmost four stretch in proportion with the window.

Code:

```
def createWindow(show) do
    mainWindow name: :multi_stretchable_sizer_window, show: show do
      frame id: :str_sz_frame,
            title: "Multiple Stretchable Sizers Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 1, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBROWN)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxORANGE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Multiple Stretchable Sizers Test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Multiple_strechable_sizers.png "Stretchable Sizers window.")

### Sizers -> Multi Weighted Sizers

Uses a box sizer to arrange 6 windows with coloured backgrounds layed out horizontally. When the main window is resized, two stay the same width, and the rightmost four stretch in proportion with the window. The proportions with which the rightmost four s tretchare 3:1, 1:1, 1:1 and 1:1.

Code:

```
def createWindow(show) do
    mainWindow name: :multi_stretchable_sizer_window, show: show do
      frame id: :wtd_str_sz_frame,
            title: "Weighted Stretchable Sizers Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 3, flag: @wxEXPAND]
            layout3 = [proportion: 1, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBROWN)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout3) do
              bgColour(@wxORANGE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout3) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "Weighted Stretchable Sizers Test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Weighted_stretchable_sizers.png "Stretchable Sizers window.")

### Sizers -> Edge Affinity

Uses a box sizer to arrange 5 windows with coloured backgrounds layed out horizontally. When the main window is resized, two stay the same width, and the leftmost will align to the top edge, the middle one will align to the centre, and the rightmost will align at the bottom. 

Code:

```
  def createWindow(show) do
    mainWindow name: :affinity_sizer_window, show: show do
      frame id: :vert_sz_frame,
            title: "Edge Affinity Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_TOP}]
            ) do
              bgColour(@wxWHITE)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxEXPAND}]
            ) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_CENTER}]
            ) do
              bgColour(@wxRED)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxEXPAND}]
            ) do
              bgColour(@wxBLUE)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_BOTTOM}]
            ) do
              bgColour(@wxGREEN)
            end
          end
        end

        statusBar(text: "ElixirWx Edge Affinity Sizer test")
      end
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Edge_affinity_sizer.png "Edge affinity sizer window.")

### Sizers -> Centering test

Centeres a window in the frame

Code:

```
  def createWindow(show) do
    mainWindow name: :sizer_center_window, show: show do
      frame id: :wtd_str_sz_frame,
            title: "Centering Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxVERTICAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 0, flag: @wxALIGN_CENTER]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBLACK)
            end

            spacer(size: {0, 0}, layout: [{:proportion, 1}])

            window(style: @wxBORDER_SIMPLE, size: {50, 50}, layout: layout2) do
              bgColour(@wxBROWN)
            end

            spacer(size: {0, 0}, layout: [{:proportion, 1}])

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end
          end
        end

        statusBar(text: "ElixirWx Centering Sizer test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Centering_test.png "Centering test.")

### Sizers -> Spacer test

Add a spacer.

Code:

```
  def createWindow(show) do
    mainWindow name: :sizer_spacer_window, show: show do
      frame id: :wtd_str_sz_frame,
            title: "Spacer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 1, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBROWN)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            spacer(size: {60, 20}, layout: layout1)

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Spacer test")
      end

      events(
        close_window: []
      )
    end
  end
```

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Spacer_test.png "Spacer test.")

