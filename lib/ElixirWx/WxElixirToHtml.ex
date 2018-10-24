defmodule ElixirToHtml do
  @argument_colour 'sienna'
  @atom_colour 'blue'
  @block_colour '#A74AC7'
  @comment_colour 'gray'
  @define_colour 'red'
  @directive_colour 'red'
  @identifier_colour 'black'
  # @key_colour 'sky blue'
  @module_colour 'sienna'
  @nullarg_colour 'gray'
  @string_colour 'green'

  require Logger

  @doc """
    Colourise the contents of the input file, checking that the input file is OK.
  """
  def fileToHtmlFile(inputFile, outputFile \\ :nofile) do
    case getFiles(inputFile) do
      {:error, why} ->
        IO.puts(why)

      {:ok, inputFile, output} ->
        case outputFile do
          :nofile -> parse(inputFile, output)
          _ -> parse(inputFile, outputFile)
        end
    end
  end

  def fileToHtml(inputFile) do
    case getFiles(inputFile) do
      {:error, why} -> IO.puts(why)
      {:ok, inputFile, _outputFile} -> parse(inputFile, :text)
    end
  end

  def stringToHtml(code) do
    tokens =
      case lex(code) do
        {:ok, tokens} ->
          tokens

        why ->
          IO.puts(why)
          []
      end

    Enum.join(colourize(tokens))
  end

  @doc """
    Colourize the given file, returning an HTML string
  """
  def parse(inputFile, outputFile) do
    tokens =
      case File.read(inputFile) do
        {:ok, code} ->
          case lex(code) do
            {:ok, tokens} ->
              tokens

            why ->
              IO.puts(why)
              []
          end

        {:error, why} ->
          IO.puts(why)
          []
      end

    html = Enum.join(colourize(tokens))

    case outputFile do
      :text -> html
      _ -> File.write(outputFile, html, [:write])
    end
  end

  @doc """
  Iterate over the list of tokens returned by lex, turning them into HTML
  """
  # Logger.info("#{inspect(tokens)}")
  def colourize(tokens) do
    html = colourize(tokens, ["<font face=\"verdana\", size=\"2\">"], args: false)
    Enum.reverse(html)
  end

  def colourize([], html, _) do
    ["</font>" | html]
  end

  def colourize([{type, line, this_token} | tokens], html, flags) do
    this_token = encode_entities(this_token)

    {colour, token, flags} =
      case type do
        :atom ->
          {@atom_colour, this_token, flags}

        :argsbegin ->
          flags = Keyword.replace!(flags, :args, true)
          {nil, this_token, flags}

        :argsend ->
          flags = Keyword.replace!(flags, :args, false)
          {nil, this_token, flags}

        :block ->
          {@block_colour, this_token, flags}

        :brackets ->
          {nil, this_token, flags}

        :comment ->
          {@comment_colour, "#{this_token}<br>", flags}

        :define ->
          {@define_colour, this_token, flags}

        :directive ->
          {@directive_colour, this_token, flags}

        :eol ->
          {nil, "<br>\n", flags}

        :identifier ->
          case flags[:args] do
            false -> {@identifier_colour, this_token, flags}
            true -> {@argument_colour, this_token, flags}
          end

        :integer ->
          {nil, this_token, flags}

        :module ->
          {@module_colour, this_token, flags}

        :nullarg ->
          {@nullarg_colour, this_token, flags}

        :pointer ->
          {nil, this_token, flags}

        :punctuation ->
          {nil, this_token, flags}

        :string ->
          # Logger.info("String: #{inspect({type, line, this_token})}")
          {@string_colour, this_token, flags}

        :syntax ->
          {nil, this_token, flags}

        :whitespace ->
          {nil, "&nbsp;", flags}

        _ ->
          Logger.error("Unhandled token: #{inspect({type, line, this_token})}")
          {nil, this_token, flags}
      end

    htmlToken = colour(token, colour)
    colourize(tokens, [htmlToken | html], flags)
  end

  @doc """
  Vgiven a token and a colour, return the necessary HTML
  """
  def colour(token, nil), do: "#{token}"
  def colour(token, colour), do: "<font color=\"#{colour}\">#{token}</font>"

  @doc """
  Interface to leex
  """
  def lex(s) when is_binary(s), do: s |> to_charlist |> lex

  def lex(s) do
    case :elixir_lexer.string(s) do
      {:ok, tokens, _} ->
        {:ok, tokens}

      {:error, {1, :elixir_lexer, {:illegal, 'd'}}, 1} ->
        Logger.error("lexer error: #{inspect({:error, {1, :elixir_lexer, {:illegal, 'd'}}, 1})}")
        {:error, []}
    end
  end

  @doc """
  Encode the HTML entities so that the dont screw up the HTML representation.
  """
  def encode_entities(charlist) do
    Enum.map(charlist, fn x -> encode_entity(x) end)
  end

  defp encode_entity(x) do
    char =
      case [x] do
        '<' -> '&lt;'
        '>' -> '&gt;'
        '&' -> '&amp;'
        '"' -> '&quot;'
        '\'' -> '&apos;'
        _ -> x
      end

    char
  end

  @doc """
  Given the input file from the command line, normalize it, and generate an html
  file name for the output.
  """
  def getFiles(input) do
    # Logger.info("input = #{inspect(input)}")

    input =
      case String.first(input) do
        "/" -> input
        _ -> System.cwd() |> Path.join(input)
      end

    case File.exists?(input) do
      true ->
        res = String.split(String.reverse(input), ".", parts: 2)

        output =
          case res do
            [_ext, path] -> String.reverse(path) <> ".html"
            [path] -> String.reverse(path) <> ".html"
          end

        {:ok, input, output}

      false ->
        {:error, "The file #{inspect(input)} does not exist"}
    end
  end
end
