defmodule TestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Test",
            size: {320, 150} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            spacer(space: 20)

            boxSizer id: :main_sizer,
                     orient: @wxVERTICAL do
              spacer(space: 10)

              #  Button Test
              boxSizer id: :message_dialog_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :msg_dlg_test, label: "&Message Dialog", size: {120, 20})
                spacer(space: 10)
                staticText(id: :msg_dlg_st, text: "Test of message dialog.")
              end

              #  Menu Demo
              boxSizer id: :menus_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :menus_demo, label: "&Menu Demo", size: {120, 20})
                spacer(space: 10)
                staticText(id: :menus_demo_op, text: "Demo of various menus.")
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

      event(:close_window, &WxTest.windowClosed/3)
      event(:command_button_clicked)
    end
  end
end