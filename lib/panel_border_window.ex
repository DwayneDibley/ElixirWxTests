defmodule PanelBorderWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :box_sizer_window, show: show, pos: {300, 250}, size: {400, 120} do
      frame id: :main_frame,
            title: "Panel Borders Test" do
        panel id: :panel_1, style: @wxSIMPLE_BORDER do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL, border: @wxALL do
            panel id: :panel_1, style: @wxSIMPLE_BORDER do
            end

            panel id: :panel_2, style: @wxRAISED_BORDER do
            end

            panel id: :panel_3, style: @wxSUNKEN_BORDER do
            end

            panel id: :panel_4, style: @wxNO_BORDER do
            end
          end

          statusBar(text: "ElixirWx Panel Border test")
        end
      end

      events(
        command_menu_selected: [handler: &BoxSizer.commandButton/4],
        close_window: []
      )
    end
  end
end
