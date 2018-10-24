defmodule WxCodeWindow do
  require Logger

  import WxUtilities
  import WinInfo

  @doc """
  Get the window options and create a new window.
  """
  def new(parent, attributes) do
    new_id = :wx_misc.newId()

    defaults = [id: "_no_id_#{inspect(new_id)}", style: nil, size: nil]
    {id, options, restOpts} = getOptions(attributes, defaults)

    Logger.debug("  :wxHtmlWindow.new(#{inspect(parent)}, #{inspect(options)}")

    # , options)
    win = :wxHtmlWindow.new(parent, options)
    put_table({id, new_id, win})

    defaults = [file: nil, code: nil]
    {_, content, _restOpts} = getOptions(restOpts, defaults)

    case content[:file] do
      nil ->
        case content[:code] do
          nil ->
            Logger.debug("WxCodeWindow: No content specified")

          code ->
            Logger.debug(":wxCodeWindow.setPage(#{inspect(win)}, #{inspect(code)})")
            html = ElixirToHtml.stringToHtml(code)
            :wxHtmlWindow.setPage(win, html)
        end

      file ->
        html = ElixirToHtml.fileToHtml(file)
        :wxHtmlWindow.setPage(win, html)
        # loadFile(win, file)
    end

    {id, new_id, win}
  end

  def loadFile(win, fileName) do
    path =
      case String.starts_with?(fileName, "/") do
        true -> fileName
        false -> Path.relative_to_cwd(fileName)
      end

    Logger.debug("  path: #{inspect(path)}")
    :wxHtmlWindow.loadFile(win, path)
  end

  def processFile(filename) do
    path =
      case String.starts_with?(filename, "/") do
        true -> filename
        false -> Path.relative_to_cwd(filename)
      end

    Logger.info("path = #{inspect(path)}")
    {:ok, code} = File.read(path)
    # Logger.info("code = #{inspect(code)}")
    processCode(code)
  end

  def processCode(code) do
    # html = process(code)
    # html = "<font face=\"verdana\", size=\"3\">" <> html <> "<font>"
    # Logger.info("code = #{inspect(html)}")
    # html
    ""
  end
end
