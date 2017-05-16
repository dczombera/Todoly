defmodule TodoServerTest do
  use ExUnit.Case, async: false

  setup do
    :meck.new(Todo.Database, [:no_link])
    :meck.expect(Todo.Database, :get,   fn(_) -> nil end)
    :meck.expect(Todo.Database, :store, fn(_, _) -> :ok end)

    {:ok, todo_server} = Todo.Server.start_link("test_list") 

    on_exit(fn ->
      :meck.unload(Todo.Database) 
      send(todo_server, :stop)
    end)

    {:ok, todo_server: todo_server}
  end
  
  test "add_entry", context do
    assert([] == Todo.Server.entries(context[:todo_server], {2017, 05, 14}))

    Todo.Server.add_entry(context[:todo_server], %{date: {2017, 05, 14}, title: "World Domination"})
    assert(1 == Todo.Server.entries(context[:todo_server], {2017, 05, 14}) |> length)
    assert("World Domination" == (Todo.Server.entries(context[:todo_server], {2017, 05, 14}) |> Enum.at(0)).title)
  end
end
