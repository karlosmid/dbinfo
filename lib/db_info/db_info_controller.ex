defmodule DbInfoWeb.DbInfoController do
  use DbInfoWeb, :controller

  def home(conn, _params) do
    schemas = DbInfo.DbInfo.list_schemas()
    render(conn, "index.html", schemas: schemas)
  end

  def show(conn, %{"shema" => shema, "page" => page}) do
    entries = DbInfo.DbInfo.paginate(DbInfo.DbInfo.to_schema(shema), page)
    render(conn, "show.html", entries: entries, shema: shema)
  end

  def attributes(conn, %{"shema" => shema}) do
    entries = DbInfo.DbInfo.list_attributes_with_types(DbInfo.DbInfo.to_schema(shema))
    render(conn, "attributes.html", entries: entries, shema: shema)
  end
end
