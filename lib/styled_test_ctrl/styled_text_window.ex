defmodule StyledTextWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :simple_frame_window, show: show, setFocus: true do
      # Create a simple frame.
      frame id: :main_frame,
            title: "Styled Text Window",
            size: {320, 150},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            layout1 = [proportion: 1, flag: @wxEXPAND]

            styledTextControl id: :stc, layout: layout1 do
            end
          end
        end
      end

      events(close_window: [])
    end
  end
end
