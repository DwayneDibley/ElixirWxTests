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
            html = processCode(code)
            :wxHtmlWindow.setPage(win, html)
        end

      file ->
        html = processFile(file)
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
    html = process(code)
    html = "<font face=\"verdana\", size=\"3\">" <> html <> "<font>"
    # Logger.info("code = #{inspect(html)}")
    html
  end

  process("", html) do
    html
  end

  def process(code, html) do
    code = String.codepoints(code)
    {token, rest} = getToken(code)
    process(rest, [toHtml(token) | html])
  end

  def getToken(code) do
    getToken([], code)
  end

  def getToken(token, []) do
    {token, ""}
  end

  def getToken([], [h | rest]) do
  end

  def getToken(token, [h | rest]) do
  end

  # ------------------------------------

  def do_code(code) do
    lines = String.split(code, "\n", trim: false)
    html = do_lines(lines, [], [])
  end

  def do_lines([], html) do
    Enum.join(Enum.reverse(html), "<br>")
  end

  def do_lines([line | rest], html) do
    Logger.info("line in = #{inspect(line)}")
    line = do_tokens(line)
    Logger.info("line out = #{inspect(line)}")
    do_lines(rest, [line | html])
  end

  def do_tokens(line) do
    tokens = String.split(line, " ", trim: false)
    Logger.info("tokenList in = #{inspect(tokens)}")
    html = do_tokens(tokens, [], [])
    Logger.info("tokenList out = #{inspect(html)}")
    Enum.join(Enum.reverse(html), " ")
  end

  def do_tokens([], html, _) do
    html
  end

  def do_tokens([token | rest], html, flags) do
    Logger.info("token = #{inspect(token)}")

    {token, flags} =
      case String.first(token) do
        "@" ->
          {define(token), flags}

        ":" ->
          {atom(token), flags}

        nil ->
          doKeyword(token, flags)

        first ->
          case isUpperCase(first) do
            true -> {atom(token), flags}
            false -> doKeyword(token, flags)
          end
      end

    do_tokens(rest, [token | html], flags)
  end

  def doKeyword(token, flags) do
    token =
      case {token, flags[:def]} do
        {"", _} -> "&nbsp;"
        {"defmodule", _} -> blockControl(token)
        {"def", _} -> blockControl(token)
        {"defp", _} -> blockControl(token)
        {"do", _} -> blockControl(token)
        {"end", _} -> blockControl(token)
        {"use", _} -> directive(token)
        {"import", _} -> directive(token)
        {token, true} -> function(token)
        _ -> token
      end

    {token, flags}
  end

  def blockControl(token) do
    "<font color=\"#8B008B\">#{token}</font>"
  end

  def directive(token) do
    "<font color=\"magenta\">#{token}</font>"
  end

  def define(token) do
    "<font color=\"red\">#{token}</font>"
  end

  def atom(token) do
    "<font color=\"#D2691E\">#{token}</font>"
  end

  def isUpperCase(str) do
    String.contains?(str, [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ])
  end
end
