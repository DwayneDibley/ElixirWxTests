[TOC]

# ElixirWx user guide

## Introduction.

## Creating a window.

A window is created by calling WxWinObj.API.newWindow(). This will create a window in a new process. This function takes the parameters:

- The window specification module..

- Options:

  Name: The name with which the window will be referenced.

  Show: Show the window on creation.

 The window specification module contains code specifying the structure of the window and the event linkage. Various options are available to name the process and to control its visibility.



```Elixir
defmodule MyApp do
    import WxWinObj.API

    def createNewWindow() do
        newWindow(ToolBarWindow, name: TestWindow, show: true)
        waitForWindowClose(TestWindow)
    end
end

```

The window specification module contains the code to create the window.  It is written using a set of macros that allows the code to reflect the structure of the window, as in the following example:

```elixir
defmodule ToolBarWindow do
  use WxDsl
  import WxDefines

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
        command_menu_selected: [handler: &ToolBar.commandButton/4],
        close_window: []
      )
    end
  end
end

```

Running this code will create a window which looks like this:

![alt text](https://raw.githubusercontent.com/DwayneDibley/ElixirWxTests/master/screenshots/Simple_tool_bar.png "Simple Frame window.")


xxx