defmodule EdgeAffinitySizerWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow name: :affinity_sizer_window, show: show do
      frame id: :vert_sz_frame,
            title: "Edge Affinity Sizer Test",
            size: {350, 250},
            pos: {300, 250} do
        panel id: :main_panel do
          boxSizer orient: @wxHORIZONTAL do
            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_TOP}]
            ) do
              bgColour(@wxWHITE)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxEXPAND}]
            ) do
              bgColour(@wxYELLOW)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_CENTER}]
            ) do
              bgColour(@wxRED)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxEXPAND}]
            ) do
              bgColour(@wxBLUE)
            end

            window(
              style: @wxBORDER_SIMPLE,
              size: {50, 25},
              layout: [{:proportion, 1}, {:flag, @wxALIGN_BOTTOM}]
            ) do
              bgColour(@wxGREEN)
            end
          end
        end

        statusBar(text: "ElixirWx Sizer test")
      end
    end
  end
end
