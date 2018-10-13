defmodule WxUtilities do

  require Logger
  @moduledoc """
  ## General utilities
  """

  @doc """
  Given a list of otions, remove the ones not in the allowed key list.
  Returns {[options], [errors]}
  Where errors are any options not in the allowed list
  """
  def getOptions(options, defaults) do
    getOptions(options, defaults, [])
  end

  defp getOptions(options, [], opts) do
    Logger.info("options=#{inspect(options)}")
    {{:id, id}, opts} = List.keytake(opts, :id, 0)
    Logger.info("ID=#{inspect(id)}")
    {id, opts, options}
  end

  defp getOptions(options, [{key, default} | t], opts) do
    {options, opts} =
      case options[key] do
        nil ->
          case default do
            nil -> {options, opts}
            _ -> {options, [{key, default} | opts]}
          end
        _ ->
          {opt, options} = List.keytake(options, key, 0)
          {options, [opt | opts]}
      end

    getOptions(options, t, opts)
  end
end
