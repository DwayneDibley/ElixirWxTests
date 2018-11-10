

# ElixirWx

[TOC]

## Window Object

A window is created in its own process using the WxWinObj.API.newWindow() function.

### WxWinObj.API

#### newWindow()





## Window Specification Macros

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


<div style="page-break-after: always;"></div>


### layout

This macro specifies a layout for a control  when adding it to a sizer. If an id is specified, then the layout, once specified is available globally.

| Parameter           | Description                                                  | Value                                                        | Default |
| ------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------- |
| id:                 | The id by which the layout can be referred to globally.      | atom()                                                       | none    |
| width:  height: | The dimension of a spacer to be added to the sizer. Adding spacers to sizers gives more flexibility in the design of dialogs; imagine for example a horizontal box with two buttons at the bottom of a dialog: you might want to insert a space between the two buttons and make that space stretchable using the *proportion* flag and the result will be that the left button will be aligned with the left side of the dialog and the right button with the right side - the space in between will shrink and grow with the dialog. | Integer()                                                    | none    |
| proportion:         | Although the meaning of this parameter is undefined in wxSizer, it is used in wxBoxSizer to indicate if a child of a sizer can change its size in the main orientation of the wxBoxSizer - where 0 stands for not changeable and a value of more than zero is interpreted relative to the value of other children of the same wxBoxSizer. For example, you might have a horizontal wxBoxSizer with three children, two of which are supposed to change their size with the sizer. Then the two stretchable windows would get a value of 1 each to make them grow and shrink equally with the sizer's horizontal dimension. | Integer()                                                    | none    |
| border_width:       | Determines the border width, if the border_flags: parameter is set to include any border flag. | Integer()                                                    | none    |
| border_flags: | These flags are used to specify which side(s) of the sizer item border_width: will apply to. | @wxTOP @wxBOTTOM @wxLEFT @wxRIGHT @wxALL | none |
| align: | The wxALIGN flags allow you to specify the alignment of the item within the space allotted to it by the sizer, adjusted for the border if any. | @wxALIGN_CENTRE @wxALIGN_CENTER @wxALIGN_LEFT @wxALIGN_RIGHT @wxALIGN_TOP @wxALIGN_BOTTOM @wxALIGN_CENTRE_VERTICAL @wxALIGN_CENTER_VERTICAL @wxALIGN_CENTRE_HORIZONTAL @wxALIGN_CENTER_HORIZONTAL |  |
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

<div style="page-break-after: always;"></div>

### mainWindow

This is the top level window and should be the outer element of a window specification. This window performs the initialisation. 

| Parameter | Description                                                  | Value     | Default                |
| --------- | ------------------------------------------------------------ | --------- | ---------------------- |
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

### 