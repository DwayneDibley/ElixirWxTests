defmodule StaticBoxSizerWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :static_box_sizer_window, show: show do
      frame id: :main_frame,
            title: "Static Box Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            staticBoxSizer id: :inner_sizer, orient: @wxVERTICAL, label: "Static Box Sizer Label" do
              # border(size: 20, flags: wxEXPAND | wxALL)
              button(id: :button1, label: "&Button 1") do
                # layout(
                #   id: :button_layout,
                #   proportion: 3,
                #   border_width: 4,
                #   border_flags: @wxALL,
                #   align: @wxALIGN_CENTRE
                # )
              end

              button(id: :button2, label: "&Button 2") #, layout: :button_layout)

              # layout(:button_layout,
              #   id: :button_layout_new,
              #   proportion: 13,
              #   border_width: 14,
              #   border_flags: 15
              # )

              button(id: :button3, label: "&Button 3") #, layout: [flag: @wxALIGN_BOTTOM])
            end
          end
        end

        statusBar(text: "ElixirWx Static Box Sizer test")
      end

      events(
        command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
