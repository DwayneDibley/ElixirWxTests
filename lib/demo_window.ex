defmodule DemoWindow do
  use WxDsl

  def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Demo",
            size: {300, 150} do

        panel id: :main_panel do

          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            spacer(space: 20)

            boxSizer id: :main_sizer,
                     orient: @wxVERTICAL do
              spacer(space: 10)

              #  Button Demo
              boxSizer id: :buttons_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :button_demo, label: "&Button Demo", size: {100, 20})
                spacer(space: 10)
                staticText(id: :button_demo_op, text: "Demo of various buttons.")
              end

              #  Menu Demo
              boxSizer id: :menus_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :menus_demo, label: "&Menu Demo", size: {100, 20})
                spacer(space: 10)
                staticText(id: :menus_demo_op, text: "Demo of various menus.")
              end

              # Exit
              boxSizer id: :exit_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :exit_btn, label: "&Exit", size: {100, 20})
                spacer(space: 10)
                staticText(id: :exit_op, text: "Exit the demo.")

              end

            end
          end
        end
      end

      event(:close_window, &Demo.windowClosed/3)
      event(:command_button_clicked)
    end
  end
end
