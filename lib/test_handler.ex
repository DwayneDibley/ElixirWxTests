defmodule TestHandler do
  require Logger
  import WxWinObj.API

  def do_menu_click(sender) do
    Logger.info("TestHandler: do_menu_click(#{inspect(sender)})")

    case sender do
      :simple_frame ->
        # newWindow(, {SimpleFrameWindow, nil}, true)
        #newWindow(SimpleFrameWindow, nil, name: :simple_frame_test)
        window = newWindow(SimpleFrameWindow, nil, name: nil, show: true)
        showWindow(window)

      # WxWindowObject.start_link(SimpleFrameWindow, nil, true)

      #
      #   :tool_bar ->
      #     spawn_link(fn -> ToolBar.run() end)
      #
      #   :box_sizer ->
      #     spawn_link(fn -> BoxSizer.run() end)
      #
      #   :static_box_sizer ->
      #     spawn_link(fn -> StaticBoxSizer.run() end)
      #
      #   :panel_borders ->
      #     spawn_link(fn -> PanelBorders.run() end)
      #
      #   :test_code ->
      #     spawn_link(fn -> TestCode.run() end)
      #
      #   :vertical_sizer ->
      #     spawn_link(fn -> VerticalSizer.run() end)
      #
      #   :horizontal_sizer ->
      #     spawn_link(fn -> HorizontalSizer.run() end)
      #
      #   :stretchable_sizer ->
      #     spawn_link(fn -> SizerStretchable.run() end)
      #
      #   :stretchable_sizers ->
      #     spawn_link(fn -> SizerMultiStretchable.run() end)
      #
      #   :weighted_sizers ->
      #     spawn_link(fn -> SizerWeightedStretchable.run() end)
      #
      #   :edge_affinity ->
      #     spawn_link(fn -> EdgeAffinitySizer.run() end)
      #
      #   :spacer ->
      #     spawn_link(fn -> SizerSpacer.run() end)
      #
      #   :center ->
      #     spawn_link(fn -> SizerCentering.run() end)
      #
      #   :dialogs ->
      #     spawn_link(fn -> DialogTest.run() end)
      #
      #   :button ->
      #     spawn_link(fn -> ButtonTest.run() end)
      #
      #   :code_window ->
      #     spawn_link(fn -> CodeWindow.run(__ENV__.file) end)
      #
      #   :exit ->
      #     :closeWindow
      #
      _ ->
        Logger.error("Unhandled menu click #{inspect(sender)}")
    end
  end
end
