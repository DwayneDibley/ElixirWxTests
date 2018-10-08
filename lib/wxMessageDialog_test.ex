defmodule WxMessageDialogTest do
  import WxFunctions
  require Logger
  use WxDefines

  @moduledoc """
  ```
  A demo of the WxWindows DSL for creating GUIs.
  """

  @doc """
  The main entry point:
  - Set the application title.
  - Create the GUI.
  Then loop waiting for events.

  """
  def run() do
    ret = WxMessageDialog.create(nil, "test1: Simple")
    Logger.info("Test1 returned #{inspect(ret)}")

    ret = WxMessageDialog.create(nil, "test2: With a caption", caption: "This is the caption")
    Logger.info("Test2 returned #{inspect(ret)}")

    ret =
      WxMessageDialog.create(nil, "pos: {10, 10}\nDoes not seem to work.",
        caption: "Test 3: Setting the position.",
        style: @wxLeft,
        pos: {10, 10}
      )

    Logger.info("Test3 returned #{inspect(ret)}")

    ret =
      WxMessageDialog.create(nil, "style: @wxYES_NO",
        caption: "Test 4: Yes and No buttons",
        style: @wxYES_NO
      )

    Logger.info("Test4 returned #{inspect(ret)}")

    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL\nProduces ok and cancel!!",
        caption: "Test 5: Ok and Cancel buttons",
        style: @wxCANCEL
      )

    Logger.info("Test5 returned #{inspect(ret)}")

    ret =
      WxMessageDialog.create(nil, "modal: false",
        caption: "Test 6: Create and show separately.",
        modal: false
      )

    Logger.info("Test6 returned #{inspect(ret)}")
    # Modal is the default
    WxMessageDialog.show(ret, false)

    Logger.info("ElixirWx Message Dialog test Exiting")
    :ok
  end
end
