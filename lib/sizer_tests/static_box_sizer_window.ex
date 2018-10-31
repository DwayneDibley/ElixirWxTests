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
              button(id: :button1, label: "&Button 1")
              button(id: :button2, label: "&Button 2")
              button(id: :button3, label: "&Button 3")
            end
          end
        end

        statusBar(text: "ElixirWx Static Box Sizer test")
      end

      events(
        close_window: []
      )
    end
  end
end
