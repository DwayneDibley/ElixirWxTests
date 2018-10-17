defmodule MenuTestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :menu_test_window, show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Menu Test",
            size: {320, 150},
            pos: {300, 250} do
        menuBar do
          menu id: :file_menu, text: "&File" do
            menuItem(id: :first, text: "&First")
            menuItem(id: :last, text: "&Last")
            menuSeparator()
            menuItem(id: :exit, text: "&Exit")
          end
        end

        statusBar(title: "ElixirWx Menu Test")
        # panel id: :menu_test_panel do
        #  end
      end

      events(
        command_button_clicked: [handler: &MenuTest.commandButton/4],
        command_menu_selected: [handler: &MenuTest.commandMenu/4],
        close_window: [handler: &MenuTest.windowClosed/4]
        # timeout: [handler: &WxTest.timeout/4, delay: 5000]
      )
    end
  end
end
