defmodule Todo.ServerSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: :todo_server_supervisor)
  end

  def start_child(todo_list_name) do
    Supervisor.start_child(:todo_server_supervisor, [todo_list_name])
  end

  def init(_) do
    # Even though we are dynamically starting child processes, we have
    # to provide a child specification. It's kind of like a template
    # that is used when starting a child.
    supervise([worker(Todo.Server, [])], strategy: :simple_one_for_one)
  end
end
