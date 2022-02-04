defmodule DbInfoWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: DbInfoWeb
      import Plug.Conn
      # import Phoenix.Router.Helpers
      # import DbInfo.Gettext
    end
  end

  @doc false
  def view do
    quote do
      @moduledoc false

      use Phoenix.View,
        namespace: DbInfoWeb,
        root: "lib/db_info/templates"

      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]
      use Phoenix.HTML

      # import DbInfo.Router.Helpers
      # import DbInfo.ErrorHelpers
      # import DbInfo.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  Convenience helper for using the functions above.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
