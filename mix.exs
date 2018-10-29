defmodule WxTests.MixProject do
  use Mix.Project

  def project do
    [
      app: :wx_tests,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      # escript: escript(),
      deps: deps(),
      escript: escript(),
      docs: docs()
    ]
  end

  # Must be added.
  def escript do
    [main_module: Test]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Test, []},
      # mod: {MenuTest, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:elixirwx, git: "https://github.com/DwayneDibley/ElixirWx.git"},
      {:ex_doc, "~> 0.18"}
    ]
  end

  defp docs do
    [
      main: "readme",
      # name: "My App",
      extras: [
        "README.md",
        "CHANGELOG.md"
      ],
      # source_ref: "v#{@version}",
      # source_url: "https://github.com/elixir-lang/ex_doc",
      groups_for_modules: [
        "ElixirWx API": [
          WxDsl,
          WxWinObj.API,
          WxWinObj
        ],
        ElixirWx: [
          WxCodeWindow,
          WxDefines,
          WxEvents,
          WxFunctions,
          WinInfo,
          WxLayout,
          WxMessageDialog,
          WxMessageDialogTest,
          WxWinObject,
          WxSizer,
          WxStatusBar,
          WxTopLevelWindow,
          WxUtilities,
          WxWindow,
          LogFormatter
        ],
        Tests: [
          BoxSizer,
          BoxSizerWindow,
          ButtonTest,
          ButtonTestWindow,
          CodeWindow,
          CodeWindowWindow,
          DialogTest,
          DialogTestCode,
          DialogTestWindow,
          EdgeAffinitySizer,
          EdgeAffinitySizerWindow,
          HorizontalSizer,
          HorizontalSizerWindow,
          MenuTest,
          MenuTestWindow,
          PanelBorderWindow,
          PanelBorders,
          SimpleFrame,
          SimpleFrameWindow,
          SizerCentering,
          SizerCenteringWindow,
          SizerMultiStretchable,
          SizerMultiStretchableWindow,
          SizerSpacer,
          SizerSpacerWindow,
          SizerStretchable,
          SizerStretchableWindow,
          SizerWeightedStretchable,
          SizerWeightedStretchableWindow,
          StaticBoxSizer,
          StaticBoxSizerWindow,
          Test,
          TestCode,
          TestWindow,
          ToolBar,
          ToolBarWindow,
          VerticalSizer,
          VerticalSizerWindow
        ]
      ]
    ]
  end
end
