

# ElixirWx

[TOC]

## Window Specification Macros

### window

This is the top level of a window and should be the outer element of a window specification.

| Parameter | Description                                                  | Value     | Default                |
| --------- | ------------------------- | --------- | ---------------------- |
| name      | The name by which the window will be referred to.            | atom()    | The name of the module |
| show      | If set to true the window will be made visible when the construction is complete. If set to false, the window will be invisible until explicitly shown using :wxFrame.show(frame). | Boolean() | true                   |

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

### frame

This macro will create a frame.

**Parameters:**

| Parameter | Description                          | Value              | Default         |
| --------- | ------------------------------------ | ------------------ | --------------- |
| id        | Used to reference the frame.         | atom               | none            |
| title     | The text appearing in the title bar. | string             | ""              |
| size      | The initial size of the frame.       | {integer, integer} | System default. |
| pos       | The initial position of the frame    | {integer, integer} | System default  |

**Example:**

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



**Screenshot:**

## ![](/Users/rwe/GitHub/ElixirWxTests/screenshots/Main test window.png)

