defmodule CountdownWindow do
  use WxDsl

  def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "Countdown",
            size: {250, 150} do
        # event(:close_window, &AnotherTutorialApp.windowClosed/3)

        panel id: :main_panel do
          # event(:command_button_clicked, &AnotherTutorialApp.buttonPushed/3)

          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            spacer(space: 20)

            boxSizer id: :main_sizer,
                     orient: @wxVERTICAL do
              spacer(space: 10)

              staticBoxSizer id: :input_sizer,
                             orient: @wxHORIZONTAL,
                             label: "Enter an integer" do
                textControl(id: :time_input, value: "10")
                # set size
                spacer(space: 5)
                staticText(id: :output, text: "Output Area")
                spacer(space: 10)
              end

              boxSizer id: :button_sizer,
                       orient: @wxHORIZONTAL do
                button(id: :countdown_btn, label: "&Countdown")
                button(id: :exit_btn, label: "&Exit")
              end
            end
          end
        end
      end

      event(:close_window, &AnotherTutorialApp.windowClosed/3)
      event(:command_button_clicked)
    end
  end
end
