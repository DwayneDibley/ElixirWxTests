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

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Vertical_Sizer.png "Vertical Sizer window.")

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

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Horizontal_Sizer.png "Vertical Sizer window.")

