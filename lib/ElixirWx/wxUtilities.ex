defmodule WxUtilities do
  @doc """
  Given a list of otions, remove the ones not in the allowed key list.
  Returns {[options], [errors]}
  Where errors are any options not in the allowed list
  """
  def getOptions(options, allowed) do
    getOptions(options, allowed, [])
  end

  defp getOptions(options, [], opts) do
    {opts, options}
  end

  defp getOptions(options, [key | t], opts) do
    {options, opts} =
      case options[key] do
        nil ->
          {options, opts}

        _ ->
          {opt, options} = List.keytake(options, key, 0)
          {options, [opt | opts]}
      end

    getOptions(options, t, opts)
  end
end
