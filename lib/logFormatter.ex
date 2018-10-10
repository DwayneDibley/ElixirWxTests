defmodule LogFormatter do
  @moduledoc """
  Sensible format for log messages logged by the Logger module
  """
  def format(level, message, timestamp, metadata) do
    {date, time} = timestamp
    line = Integer.to_string(metadata[:line])
    module = inspect(metadata[:module])
    :io_lib.format("~s-~s ~s [~s:~s] ~s\n", [format_date(date), format_time(time), level, module, line, message] )
  rescue

    _ -> #message = List.flatten(message)
    "could not format: level=#{inspect(level)}, \nmessage=#{inspect(message)}, \n metadata=#{inspect(metadata)}\n"
  end

  defp format_date({yy, mm, dd}) do
    [Integer.to_string(yy), ?-, pad2(mm), ?-, pad2(dd)]
  end

  defp format_time({hh, mi, ss, ms}) do
     [pad2(hh), ?:, pad2(mi), ?:, pad2(ss), ?., pad3(ms)]
   end


  defp pad2(int) when int < 10, do: [?0, Integer.to_string(int)]
  defp pad2(int), do: Integer.to_string(int)

  defp pad3(int) when int < 10, do: [?0, ?0, Integer.to_string(int)]
  defp pad3(int) when int < 100, do: [?0, Integer.to_string(int)]
  defp pad3(int), do: Integer.to_string(int)


end
