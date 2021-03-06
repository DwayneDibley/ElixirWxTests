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
