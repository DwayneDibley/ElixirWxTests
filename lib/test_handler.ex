defmodule TestHandler do
  require Logger
  import WxWinObj.API

  def do_menu_click(sender) do
    Logger.info("TestHandler: do_menu_click(#{inspect(sender)})")

    case sender do
      :simple_frame ->
        window = newWindow(SimpleFrameWindow, nil, name: nil, show: true)

      :tool_bar ->
        newWindow(ToolBarWindow, nil, name: nil, show: true)

      :box_sizer ->
        newWindow(BoxSizerWindow, nil, name: nil, show: true)

        :static_box_sizer ->
          newWindow(StaticBoxSizerWindow, nil, name: nil, show: true)

        :panel_borders ->
          newWindow(PanelBorderWindow, nil, name: nil, show: true)

        :test_code ->
          spawn_link(fn -> TestCode.run() end)

        :vertical_sizer ->
          newWindow(VerticalSizerWindow, nil, name: nil, show: true)

        :horizontal_sizer ->
          newWindow(HorizontalSizerWindow, nil, name: nil, show: true)

        :stretchable_sizer ->
          newWindow(SizerStretchableWindow, nil, name: nil, show: true)

        :stretchable_sizers ->
          newWindow(SizerMultiStretchableWindow, nil, name: nil, show: true)

        :weighted_sizers ->
          newWindow(SizerWeightedStretchableWindow, nil, name: nil, show: true)

        :edge_affinity ->
          newWindow(EdgeAffinitySizerWindow, nil, name: nil, show: true)

        :spacer ->
          newWindow(SizerSpacerWindow, nil, name: nil, show: true)

        :center ->
          newWindow(SizerCenteringWindow, nil, name: nil, show: true)

        :dialogs ->
          spawn_link(fn -> DialogTest.run() end)

        :button ->
          newWindow(ButtonTestWindow, nil, name: nil, show: true)

        :code_window ->
          newWindow(CodeWindowWindow, nil, name: nil, show: true)
      
        :exit ->
          :closeWindow

      _ ->
        Logger.error("Unhandled menu click #{inspect(sender)}")
    end
  end

  def do_child_window_closed(sender) do
  end
end
