defmodule SizerMultiStretchableWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :multi_stretchable_sizer_window, show: show do
      frame id: :str_sz_frame,
            title: "Multiple Stretchable Sizers Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 1, flag: @wxEXPAND]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxWHITE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBROWN)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxORANGE)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout2) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxBLUE)
            end
          end
        end

        statusBar(text: "ElixirWx Vertical Sizer test")
      end

      events(
        # command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end