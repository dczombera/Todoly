defmodule Todo.Application do
  def start(_ ,_) do
    response = Todo.Supervisor.start_link
    Todo.Web.start_server
    response
  end
end
