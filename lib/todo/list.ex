defmodule Todo.List do
  defstruct auto_id: 1, entries: Map.new

  def new(entries \\ []) do
    Enum.reduce(entries, %Todo.List{}, &add_entry(&2, &1))
   end

   def size(todo_list) do
     Map.size(todo_list.entries)
   end

  def add_entry(%Todo.List{entries: entries, auto_id: auto_id} = todo_list, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %Todo.List{ todo_list | entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn({ _, entry }) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end

  def update_entry(%Todo.List{entries: entries} = todo_list, entry_id, update_fun) do
    case entries[entry_id] do
      nil       -> todo_list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = update_fun.(old_entry)
        new_entries = Map.put(entries, entry_id, new_entry)
        %Todo.List{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
  end

  def delete_entry(%Todo.List{entries: entries} = todo_list, entry_id) do
    new_entries = Map.delete(entries, entry_id)
    %Todo.List{todo_list | entries: new_entries}
  end
end

defmodule Todo.List.CSVImporter do

  def import(file) do
    file
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(&List.to_tuple/1)
    |> Stream.map(&parse_to_raw_tuple/1)
    |> Enum.map(&create_entry_map/1)
  end

  defp parse_to_raw_tuple({date, title}) do
    [ year, month, day ]= date
                          |> String.split("/")
                          |> Enum.map(&String.to_integer/1)
    { { year, month, day }, title }
  end

  defp create_entry_map({date, title}) do
    %{ date: date, title: title }
  end
end

defimpl Collectable, for: Todo.List do
  def into(original) do
    { original, &into_callback/2 }
  end

  defp into_callback(todo_list, { :cont, entry }) do
    Todo.List.add_entry(todo_list, entry)
  end

  defp into_callback(todo_list, :done), do: todo_list
  defp into_callback(_todo_list, :halt), do: :ok
end
