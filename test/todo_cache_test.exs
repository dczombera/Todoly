defmodule TodoCacheTest do
  use ExUnit.Case, async: false 

  setup do
    :meck.new(Todo.Database, [:no_link])
    :meck.expect(Todo.Database, :start_link, fn(_) -> nil end)
    :meck.expect(Todo.Database, :get, fn(_) -> nil end)
    :meck.expect(Todo.Database, :store, fn(_, _) -> :ok end)
    on_exit(fn ->
      :meck.unload(Todo.Database) 
    end)
  end

  test "server_process" do
    Todo.ServerSupervisor.start_link 
    leias_list = Todo.Cache.server_process("leias_list")
    lukes_list = Todo.Cache.server_process("lukes_list")

    assert(leias_list != lukes_list)
    assert(leias_list == Todo.Cache.server_process("leias_list"))
    assert(lukes_list == Todo.Cache.server_process("lukes_list"))

    Process.exit(Process.whereis(:todo_server_supervisor), :kill)
  end
end
