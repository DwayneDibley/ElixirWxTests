defmodule MenuTestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window show: show do
      # Create a frame with a status bar and a menu.
      frame id: :menu_test_frame,
            title: "ElixirWx Menu Test",
            size: {320, 150},
            pos: {10,10} do
        panel id: :menu_test_panel do
          end
        end
        #event(:close_window, &WxTest.windowClosed/3)
      end
  end
end
