defmodule CodeWindowWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :code_window, show: show do
      frame id: :str_sz_frame,
            title: "Code Window Test",
            size: {700, 500},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            # Definition of the layout flags to eliminate repetition.
            layout1 = [proportion: 0, flag: @wxEXPAND]

            window(
              style: @wxBORDER_SIMPLE,
              size: {100, 25},
              layout: layout1
            ) do
              bgColour(@wxWHITE)
            end

            codeWindow(
              id: :html_window,
              file: __ENV__.file,
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [proportion: 1, flag: @wxEXPAND]
            ) do
              bgColour(@wxWHITE)
            end
          end
        end

        statusBar(text: "Code Window test")
      end

      events(
        command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
