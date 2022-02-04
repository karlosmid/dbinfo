defmodule DbInfoTest do
  use ExUnit.Case, async: false
  doctest DbInfo
  alias DbInfo.DbInfo
  import Mock

  defmodule Zoom.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field(:age, :integer)
      field(:name, :string)
      field(:color, :string)
      field(:uuid, :string)

      timestamps()
    end

    @attrs [
      :age,
      :name,
      :color,
      :uuid
    ]
    @doc false
    def changeset(user, attrs) do
      user
      |> cast(attrs, @attrs)
    end
  end

  defmodule Zoom.Repo do
    def one(_query), do: 1

    def all(_query),
      do: [
        %Zoom.User{
          age: 1,
          color: "blue",
          name: "test",
          uuid: "123e4567-e89b-12d3-a456-426614174000"
        }
      ]
  end

  test "list_schemas" do
    with_mock DbInfoHelpers, get_application_modules: fn -> [Zoom.User] end do
      assert DbInfo.list_schemas() == [DbInfoTest.Zoom.User]
      assert DbInfo.to_schema("Zoom.User") == ""
    end
  end

  test "to_schema" do
    with_mock DbInfoHelpers, get_application_modules: fn -> [Zoom.User] end do
      assert DbInfo.to_schema("Zoom.User") == ""
      assert DbInfo.to_schema("DbInfoTest.Zoom.User") == DbInfoTest.Zoom.User
    end
  end

  test "get_router_helpers" do
    with_mock DbInfoHelpers, get_application_modules: fn -> [ZoomWeb.Router.Helpers] end do
      assert DbInfo.get_router_helpers() == ZoomWeb.Router.Helpers
    end
  end

  test "paginate/2" do
    with_mock DbInfoHelpers, get_application_modules: fn -> [Zoom.User, Zoom.Repo] end do
      assert DbInfo.paginate(Zoom.User, 0) == %{
               count: 1,
               first: 1,
               has_next: false,
               has_prev: false,
               last: 1,
               last_page: 0,
               list: [
                 %DbInfoTest.Zoom.User{
                   age: 1,
                   color: "blue",
                   id: nil,
                   inserted_at: nil,
                   name: "test",
                   updated_at: nil,
                   uuid: "123e4567-e89b-12d3-a456-426614174000"
                 }
               ],
               next_page: 1,
               page: 0,
               prev_page: -1
             }
    end
  end

  test "list_attributes_with_types/1" do
    assert DbInfo.list_attributes_with_types(DbInfoTest.Zoom.User) == [
             {:id, :id},
             {:age, :integer},
             {:name, :string},
             {:color, :string},
             {:uuid, :string},
             {:inserted_at, :naive_datetime},
             {:updated_at, :naive_datetime}
           ]
  end
end
