defmodule UAInspector.ShortCodeMap.ClientBrowsers do
  @moduledoc false

  use UAInspector.ShortCodeMap

  def file_local, do: "short_codes.client_browsers.yml"
  def file_remote, do: Config.database_url(:short_code_map, "Parser/Client/Browser.php")
  def to_ets([{short, long}]), do: {short, long}
  def var_name, do: "availableBrowsers"
  def var_type, do: :hash
end
