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
    Logger.info("getOptions=#{inspect(options)}")

    {new_id, new_opts} = case List.keytake(opts, :id, 0) do
      {{:id, id}, opts} -> {id, opts}
      nil -> {:_no_id_, opts}
    end

    #{{:id, id}, opts} = List.keytake(opts, :id, 0)
    #Logger.info("ID=#{inspect(id)}")
    {new_id, new_opts, options}
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
