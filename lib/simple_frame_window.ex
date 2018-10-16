defmodule SimpleFrameWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :simple_frame_window, show: show do
      # Create a simple frame.
      frame id: :main_frame,
            title: "Simple frame",
            size: {320, 150},
            pos: {300, 250} do
      end

      events(close_window: [])
    end
  end
end
