defmodule TestWindow do
  use WxDsl
  import WxDefines

  def createWindow(show) do
    mainWindow icon: "images/icons/tipi.ico", show: show do
      # Create a frame with a status bar and a menu.
      frame id: :main_frame,
            title: "ElixirWx Test",
            size: {320, 150} do
        # File Menu
        menuBar do
          menu id: :file_menu, text: "&File" do
            menuItem(id: :first, text: "&First")
            menuItem(id: :last, text: "&Last")
            menuSeparator()
            menuItem(id: :exit, text: "&Exit")
          end

          # Random code test menu
          menu id: :code_menu, text: "&Code" do
            menuItem(id: :test_code, text: "&Test Code")
            menuItem(id: :code_window, text: "&Test Code Window")
          end

          menu id: :dialog_menu, text: "&Dialogs" do
            menuItem(id: :dialogs, text: "&Dialogs")
          end

          # Panel test menu
          menu id: :panel_menu, text: "&Panels" do
            menuItem(id: :panel_borders, text: "&Panel Borders")
          end

          # Simple test menu
          menu id: :simple_menu, text: "&Simple" do
            menuItem(id: :simple_frame, text: "&Simple Frame")
            menuItem(id: :tool_bar, text: "&Tool Bar")
            menuItem(id: :button, text: "&Button")
          end

          # Sizer test menu
          menu id: :sizer_menu, text: "&Sizers" do
            menuItem(id: :box_sizer, text: "&Box Sizer")
            menuItem(id: :static_box_sizer, text: "&Static Box Sizer")
            menuItem(id: :vertical_sizer, text: "&Vertical Sizer")
            menuItem(id: :horizontal_sizer, text: "&Horizontal Sizer")
            menuItem(id: :stretchable_sizer, text: "&Stretchable Sizer")
            menuItem(id: :stretchable_sizers, text: "&Stretchable Sizers")
            menuItem(id: :weighted_sizers, text: "&Multi Weighted Sizers")
            menuItem(id: :edge_affinity, text: "&Edge Affinity")
            menuItem(id: :spacer, text: "&Spacer test")
            menuItem(id: :center, text: "&Centering test")
          end

          # Simple test menu
          menu id: :styled_text_menu, text: "&Styled Text" do
            menuItem(id: :styled_text_window, text: "&Styled_text_window")
          end

        end

        # Status bar
        statusBar(text: ["ElixirWx Menu Test", "Second text"])

        panel id: :main_panel do
          boxSizer id: :outer_sizer, orient: @wxHORIZONTAL do
            spacer(space: 20)

            boxSizer id: :main_sizer,
                     orient: @wxVERTICAL do
              spacer(space: 10)

              #  Dialog Test
              boxSizer id: :message_dialog_sizer,
                       orient: @wxHORIZONTAL do
                # layout = [proportion: 1, flag: @wxEXPAND]

                button(id: :msg_dlg_test, label: "&Message Dialog", size: {120, 20})
                spacer(space: 10)
                # staticText(id: :msg_dlg_st, text: "Test of message dialog 2.")
                staticText(id: :msg_dlg_st, text: "Test of message dialog.")
              end

            end
          end
        end
      end

      events(
        command_button_clicked: [handler: &Test.commandButton/4],
        command_menu_selected: [handler: &Test.doMenuEvent/4],
        close_window: [handler: &Test.windowClosed/4]
        # timeout: [handler: &WxTest.timeout/4, delay: 5000]
      )
    end
  end
end
