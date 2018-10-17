defmodule HorizontalSizerWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :bvertical_sizer_window, show: show do
      frame id: :vert_sz_frame,
            title: "Horizontal Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            layout1 = [proportion: 0, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Vertical Sizer test")
      end

      events(
        command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
