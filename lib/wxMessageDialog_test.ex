defmodule WxMessageDialogTest do
  #import WxFunctions
  require Logger
  use WxDefines
  import Bitwise

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
    ret = WxMessageDialog.show(ret, false)
    Logger.info("Test6 returned #{inspect(ret)}")

    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL || @wxICON_QUESTION\nShould have a question mark Icon\nDoes not work!",
        caption: "Test 7: Question Mark Icon",
        style: @wxICON_QUESTION
      )

    Logger.info("Test7 returned #{inspect(ret)}")

    # Test 8 -------------------------------------------------------------------
    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL || @wxICON_EXCLAMATION\nShould have an exclamation mark Icon",
        caption: "Test 8: Exclamation Icon",
        style: @wxICON_EXCLAMATION
      )

    Logger.info("Test8 returned #{inspect(ret)}")

    # Test 9 -------------------------------------------------------------------
    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL || @wxICON_HAND\nShould have an error Icon\nDoes not work!",
        caption: "Test 9: Hand Icon",
        style: @wxICON_HAND
      )

    Logger.info("Test9 returned #{inspect(ret)}")

    # Test 10 -------------------------------------------------------------------
    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL || @wxICON_ERROR\nShould have an error Icon\nDoes not work!",
        caption: "Test 10: Error Icon",
        style: @wxICON_ERROR
      )

    Logger.info("Test10 returned #{inspect(ret)}")

    # Test 11 -------------------------------------------------------------------
    ret =
      WxMessageDialog.create(nil, "style: @wxCANCEL || @wxICON_INFORMATION\nShould have an error Icon\nDoes not work!",
        caption: "Test 11: Information Icon",
        style: @wxICON_INFORMATION
      )

    Logger.info("Test11 returned #{inspect(ret)}")


    Logger.info("ElixirWx Message Dialog test Exiting")
    :ok
  end
end
