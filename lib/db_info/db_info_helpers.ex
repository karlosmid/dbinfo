defmodule DbInfoHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Link
  import Phoenix.HTML.Tag

  def pagination_text(list) do
    ~e"""
    <span class="tag is-info is-large">Displaying <%= list.first %>-<%= list.last %> of <%= list.count %></span>
    """
  end

  def pagination_links(conn, list, route, shema) do
    content_tag :nav, class: "pagination is-right", role: "navigation", "aria-label": "pagination" do
      children = []

      children =
        children ++
          elem(
            link("First", to: route.(conn, :show, shema, page: 0), class: "pagination-previous"),
            1
          )

      children =
        if list.has_prev do
          children ++
            elem(
              link("Previous",
                to: route.(conn, :show, shema, page: list.prev_page),
                class: "pagination-previous"
              ),
              1
            )
        else
          children
        end

      children =
        if list.has_next do
          children ++
            elem(
              link("Next",
                to: route.(conn, :show, shema, page: list.next_page),
                class: "pagination-next"
              ),
              1
            )
        else
          children
        end

      children =
        children ++
          elem(
            link("Last",
              to: route.(conn, :show, shema, page: list.last_page),
              class: "pagination-next"
            ),
            1
          )

      {:safe, children}
    end
  end

  def get_application_modules() do
    app = Application.fetch_env!(:db_info, :app)
    {:ok, modules} = :application.get_key(app, :modules)
    modules
  end
end
