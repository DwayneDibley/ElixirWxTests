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



##Sizer Tests

###Sizers -> Box Sizer

This tests some of the funtionality of a wxBoxSizer.

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
