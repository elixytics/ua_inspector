defmodule UAInspector.Parser.Device do
  @moduledoc """
  UAInspector device information parser.
  """

  use UAInspector.Parser

  alias UAInspector.Database.Devices
  alias UAInspector.Result
  alias UAInspector.Util

  def parse(ua), do: parse(ua, Devices.list)


  defp parse(_,  []),                             do: :unknown
  defp parse(ua, [{ _index, entry } | database ]) do
    if Regex.match?(entry.regex, ua) do
      parse_model(ua, entry, entry.models)
    else
      parse(ua, database)
    end
  end


  defp parse_model(_, _, []), do: :unknown

  defp parse_model(ua, device, [ model | models ]) do
    if Regex.match?(model.regex, ua) do
      parse_model_data(ua, device, model)
    else
      parse_model(ua, device, models)
    end
  end

  defp parse_model_data(ua, device, model) do
    captures  = Regex.run(device.regex, ua)
    model_str =
         (model.model || "")
      |> Util.uncapture(captures)
      |> Util.sanitize_model()
      |> Util.maybe_unknown()

    %Result.Device{
      brand: device.brand,
      type:  model.device,
      model: model_str
    }
  end
end
