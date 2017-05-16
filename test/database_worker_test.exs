defmodule DatabaseWorkerTest do
  use ExUnit.Case, async: false

  setup do
    {:ok, worker} = Todo.DatabaseWorker.start_link("./test_persist", 42)

    on_exit(fn ->
      File.rm_rf("./test_persist") 
      send(worker, :stop)
    end)

    {:ok, worker: worker}
  end

  test "get and store" do
    assert(nil == Todo.DatabaseWorker.get(42, 1))

    Todo.DatabaseWorker.store(42, "smuggler", {:han, "solo"})
    Todo.DatabaseWorker.store(42, "jedi", {:luke, "skywalker"})

    assert({:han, "solo"} == Todo.DatabaseWorker.get(42, "smuggler"))
    assert({:luke, "skywalker"} == Todo.DatabaseWorker.get(42, "jedi"))
  end
end
