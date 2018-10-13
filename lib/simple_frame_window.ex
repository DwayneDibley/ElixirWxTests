defmodule SimpleFrameWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    window name: :simple_frame_window, show: show do
      # Create a simple frame.
      frame id: :main_frame,
            title: "Simple frame",
            size: {320, 150},
            pos: {300, 250} do
      end

      events(
        command_button_clicked: [handler: &WxTest.commandButton/4],
        close_window: [handler: &SimpleFrame.windowClosed/4]
      )
    end
  end
end
