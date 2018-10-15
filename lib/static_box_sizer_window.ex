defmodule StaticBoxSizerWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window name: :box_sizer_window, show: show do
      frame id: :main_frame,
            title: "Static Box Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL, border: @wxALL do
            staticBoxSizer id: :outer_sizer, orient: @wxHORIZONTAL, border: @wxALL do
              # border(size: 20, flags: wxEXPAND | wxALL)
              button(id: :button1, label: "&Button 1") do
                layout(
                  id: :button_layout,
                  # width: 1,
                  # height: 2,
                  proportion: 3,
                  border_width: 4,
                  border_flags: @wxALL,
                  align: @wxALIGN_CENTRE
                )
              end

              button(id: :button2, label: "&Button 2", layout: :button_layout)

              layout(:button_layout,
                id: :button_layout_new,
                proportion: 13,
                border_width: 14,
                border_flags: 15
                # align: 16
              )

              button(id: :button3, label: "&Button 3", layout: :button_layout_new)
            end
          end
        end

        statusBar(text: "ElixirWx Box Sizer test")
      end

      events(
        command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
