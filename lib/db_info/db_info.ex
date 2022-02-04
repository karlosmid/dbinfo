defmodule DbInfo.DbInfo do
  import Ecto.Query

  @moduledoc """
  Pagination based on https://snippets.aktagon.com/snippets/776-pagination-with-phoenix-and-ecto
  """

  @doc """
  List application all Ecto Schemas
  """
  @spec list_schemas() :: [Ecto.Schema.schema()]
  def list_schemas() do
    DbInfoHelpers.get_application_modules()
    |> Enum.filter(&({:__schema__, 1} in &1.__info__(:functions)))
  end

  @doc """
  List Ecto Schema attributes with types
  """
  @spec list_attributes_with_types(Ecto.Schema.schema()) :: {atom(), atom()}
  def list_attributes_with_types(schema) do
    schema.__schema__(:fields)
    |> Enum.map(fn field -> {field, schema.__schema__(:type, field)} end)
  end

  defp list_modules() do
    DbInfoHelpers.get_application_modules()
  end

  @doc """
  Map schema name to actual Ecto Schema
  """
  @spec to_schema(String.t()) :: Ecto.Schema.schema()
  def to_schema(string) do
    case Enum.filter(list_schemas(), fn schema -> inspect(schema) == string end) do
      [] -> ""
      [schema] -> schema
    end
  end

  defp get_repo() do
    [repo] =
      Enum.filter(list_modules(), fn module -> String.contains?(inspect(module), "Repo") end)

    repo
  end

  @doc """
  Get application module with route helpers.
  """
  @spec get_router_helpers() :: Module.t()
  def get_router_helpers() do
    [router_helpers] =
      Enum.filter(list_modules(), fn module ->
        String.contains?(inspect(module), "Router.Helpers")
      end)

    router_helpers
  end

  defp all(schema), do: get_repo().all(schema)

  defp one(schema), do: get_repo().one(schema)

  @doc """
  Returns Ecto Schema data pagination page.
  """
  @spec paginate(Ecto.Schema.schema(), String.t()) :: struct()
  def paginate(schema, page_no),
    do:
      page(Ecto.Query.order_by(schema, desc: :inserted_at), page_no,
        per_page: 10,
        total_count:
          one(
            from(t in subquery(Ecto.Query.order_by(schema, desc: :inserted_at)),
              select: count("*")
            )
          )
      )

  defp page(query, page, per_page: per_page, total_count: total_count)
       when is_nil(page) or page < 0 or page * per_page > total_count do
    page(query, 0, per_page: per_page, total_count: total_count)
  end

  defp page(query, page, per_page: per_page, total_count: total_count) when is_binary(page) do
    page = String.to_integer(page)
    page(query, page, per_page: per_page, total_count: total_count)
  end

  defp page(query, page, per_page: per_page, total_count: total_count) do
    count = per_page + 1

    result =
      query
      |> limit(^count)
      |> offset(^(page * per_page))
      |> all()

    has_next = length(result) == count
    has_prev = page > 0

    page = %{
      has_next: has_next,
      has_prev: has_prev,
      prev_page: page - 1,
      next_page: page + 1,
      last_page: div(total_count, per_page),
      page: page,
      first: page * per_page + 1,
      last: Enum.min([page * per_page + per_page, total_count]),
      count: total_count,
      list: Enum.slice(result, 0, count - 1)
    }

    page
  end
end
