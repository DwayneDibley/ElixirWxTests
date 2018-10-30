defmodule BoxSizerWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :box_sizer_window, show: show do
      frame id: :main_frame,
            title: "Box Sizers Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            staticText(text: "hello")
            staticText(text: "world")
          end
        end
      end

      events(
        close_window: []
      )
    end
  end
end
