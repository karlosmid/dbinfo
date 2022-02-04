defmodule DbInfo.Router do
  @moduledoc """
  Provides View routing for DbInfo.
  """

  @doc """
  Defines a DbInfo route.
  It expects the `path` the dashboard will be mounted at.

  This will also generate a named helper called `db_info_path/2`
  which you can use to link directly to the dashboard, such as:
      <%= link "DbInfo", to: dbinfo_path(conn, :home) %>


  """
  defmacro dbinfo(path) do
    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        get("/", DbInfoWeb.DbInfoController, :home)
        get("/:shema", DbInfoWeb.DbInfoController, :show)
        get("/attributes/:shema", DbInfoWeb.DbInfoController, :attributes)
      end
    end
  end
end
