defmodule ButtonTestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow icon: "images/icons/tipi.ico", show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "Button Test",
            size: {320, 150} do
        # File Menu
        menuBar do
          menu id: :file_menu, text: "&File" do
            menuItem(id: :exit, text: "&Exit")
          end
        end

        # Status bar
        statusBar(text: ["ElixirWx Menu Test", "Second text"])

        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            spacer(space: 20)

            boxSizer id: :main_sizer,
                     orient: @wxVERTICAL do
              spacer(space: 10)

              #  Simple Button Test
              boxSizer id: :message_dialog_sizer,
                       orient: @wxHORIZONTAL do
                layout = [proportion: 1, flag: @wxEXPAND]

                button(id: :msg_dlg_test, label: "&Simple button", size: {120, 20})
                spacer(space: 10)
                staticText(id: :msg_dlg_st, text: "A standard button.")
              end

              #  Menu Demo
              boxSizer id: :menus_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :menu_test, label: "&Menu", size: {120, 20}, layout: layout)
                spacer(space: 10)
                staticText(id: :menu_test, text: "Test of various menus.")
              end

              #  Test
              boxSizer id: :menus_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :test, label: "&test_code", size: {120, 20})
                spacer(space: 10)
                staticText(id: :menu_test, text: "Random test code.")
              end

              # Exit
              boxSizer id: :exit_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :exit_btn, label: "&Exit", size: {120, 20})
                spacer(space: 10)
                staticText(id: :exit_op, text: "Exit the demo.")
              end
            end
          end
        end
      end

      events(
        command_button_clicked: [handler: &Test.commandButton/4],
        command_menu_selected: [handler: &Test.doMenuEvent/4],
        close_window: [handler: &Test.windowClosed/4]
        # timeout: [handler: &WxTest.timeout/4, delay: 5000]
      )
    end
  end
end
