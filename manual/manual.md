# ElixirWx

Window Specification Macros

## window

This is the top level of a window and should be the outer element of a window specification.

| Parameter | Value     | Description                                                  | Default |
| --------- | --------- | ------------------------------------------------------------ | ------- |
| name      | atom()    | The name by which the window will be referred to.            | none    |
| show      | Boolean() | If set to true the window will be made visible when the construction is complete. If set to false, the window will be invisible until explicitly shown using :wxFrame.show(frame). | true    |

Example:

```
defmodule TestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
      ...
      ...
      end
    end
  end

```

## frame

This macro will create a frame.



| Parameter | Value                  | Description                                | Default |
| --------- | ---------------------- | ------------------------------------------ | ------- |
| id        | atom()                 | The name the frame will be referenced by.  | none    |
| title     | string()               | The text to be inserted into the title bar | none    |
| size      | {integer(), integer()} | The initial size of the frame.             | none    |

Example:

```
def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Test",
            size: {320, 150} do
            ...
            ...
      end
    end
  end

```

## 

