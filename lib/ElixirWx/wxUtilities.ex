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

    {new_id, new_opts} =
      case List.keytake(opts, :id, 0) do
        {{:id, id}, opts} -> {id, opts}
        nil -> {:_no_id_, opts}
      end

    # {{:id, id}, opts} = List.keytake(opts, :id, 0)
    # Logger.info("ID=#{inspect(id)}")
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

  @doc """
  Given a list of otions, remove the ones not in the allowed key list.
  Returns {id, [options], layout, [errors]}
  where:
  id = value of the option key or :_no_id_
  options = the list of options as specified by the defaults. If a
  layout = content of the :layout key in the options, or []
           If layout is an atom, the content of the matching layout key is returned.


  Where errors are any options not in the allowed list
  """
  def getObjOpts(options, defaults) do
    Logger.debug("getObjOpts(#{inspect(options)}, #{inspect(defaults)})")
    # get the options list.
    {options, rest} = getObjOpts(options, defaults, [])

    # Get the id from the rest list
    {id, rest} =
      case List.keytake(rest, :id, 0) do
        {{:id, id}, rest} -> {id, rest}
        nil -> {:_no_id_, rest}
      end

    # Get and remove the :layout from the options list
    {layout_spec, options} =
      case List.keytake(options, :layout, 0) do
        {{:layout, layout}, options} -> {layout, options}
        nil -> {[], options}
      end

    # If the layout is an atom, get the layout from the layout spec
    layout =
      cond do
        is_atom(layout_spec) ->
          layout =
            case WxLayout.getLayout(layout_spec) do
              nil -> []
              layout -> layout
            end

        is_list(layout_spec) ->
          layout_spec

        true ->
          []
      end

    %{:id => id, :options => options, :layout => layout, :rest => rest}
  end

  defp getObjOpts(rest, [], opts) do
    Logger.info("getObjOpts: opts=#{inspect(opts)} rest=#{inspect(rest)}")
    {opts, rest}
  end

  defp getObjOpts(options, [{key, default} | t], opts) do
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

    getObjOpts(options, t, opts)
  end
end
