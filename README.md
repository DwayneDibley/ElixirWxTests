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
