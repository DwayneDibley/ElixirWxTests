defmodule SizerCenteringWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :sizer_center_window, show: show do
      frame id: :wtd_str_sz_frame,
            title: "Centering Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxVERTICAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]
            layout2 = [proportion: 0, flag: @wxALIGN_CENTER]

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxBLACK)
            end

            spacer(size: {0, 0}, layout: [{:proportion, 1}])

            window(style: @wxBORDER_SIMPLE, size: {50, 50}, layout: layout2) do
              bgColour(@wxBROWN)
            end

            spacer(size: {0, 0}, layout: [{:proportion, 1}])

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxRED)
            end

            window(style: @wxBORDER_SIMPLE, size: {50, 25}, layout: layout1) do
              bgColour(@wxYELLOW)
            end
          end
        end

        statusBar(text: "ElixirWx Centering Sizer test")
      end

      events(
        # command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
