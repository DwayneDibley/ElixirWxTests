defmodule MenuTestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window name: :menu_test_window, show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Menu Test",
            size: {320, 150},
            pos: {300,250} do
        menuBar do
          menu id: :file_menu, text: "&File" do
            menuItem( id: :first, text: "&First")
            menuItem( id: :last, text: "&Last")
            menuSeparator()
            menuItem( id: :exit, text: "&Exit")
          end
        end
        statusBar(title: "ElixirWx Menu Test")
        #panel id: :menu_test_panel do
        #  end
        end
        #event(:close_window, &MenuTest.windowClosed/3)
        event(:close_window)
        event(:command_menu_selected)
        #event(:command_button_clicked)
      end
  end
end
