defmodule Todo.Server do
  # ********************
  # Interface functions
  # ********************
  def start_link(name) do
    IO.puts "Starting to-do list for #{name}..."
    GenServer.start_link(Todo.Server, name,
                         name: { :global, { :todo_server, name } })
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, { :add_entry, new_entry })
  end

  def entries(pid, date) do
    GenServer.call(pid, { :entries, date })
  end

  def whereis(name) do
    :global.whereis_name({ :todo_server, name })
  end

  # *******************
  # Callback Functions
  # *******************
  def init(name) do
    { :ok, { name, Todo.Database.get(name) || Todo.List.new } }
  end

  def handle_cast({ :add_entry, new_entry}, { name, todo_list }) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_state)
    { :noreply, { name, new_state } }
  end

  def handle_call({ :entries, date}, _, { name, todo_list }) do
    { :reply, Todo.List.entries(todo_list, date), { name, todo_list } }
  end
end
