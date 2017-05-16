defmodule TodoListTest do
  use ExUnit.Case, async: false
  
  test "empty list" do
    assert(0 == Todo.List.size(Todo.List.new))
  end

  test "add_entry" do
    assert(3 == Todo.List.size(sample_todo_list()))
    assert(2 == sample_todo_list() |> Todo.List.entries({2017, 05, 15}) |> length)
    assert(1 == sample_todo_list() |> Todo.List.entries({2017, 05, 14}) |> length)
    assert(0 == sample_todo_list() |> Todo.List.entries({2017, 05, 04}) |> length)

    assert(2 == world_domination().id)
    assert({2017, 05, 15} == world_domination().date)
    assert("World domination" == world_domination().title)
  end

  test "update_entry" do
    updated_list = 
      sample_todo_list()
      |> Todo.List.update_entry(world_domination().id, &Map.put(&1, :title, "Chillin"))

    assert(3 == Todo.List.size(updated_list))
    assert("Chillin" == world_domination(updated_list).title)

    not_modified_list =
      sample_todo_list()
      |> Todo.List.update_entry(-1, fn(_) -> flunk("shouldn't be executed") end)

    assert(sample_todo_list() == not_modified_list)
  end

  test "delete_entry" do
    deleted_list = sample_todo_list() |> Todo.List.delete_entry(world_domination().id)
    assert(2 == Todo.List.size(deleted_list))
    assert(1 == deleted_list |> Todo.List.entries({2017, 05, 15}) |> length)
  end

  def sample_todo_list do
    Todo.List.new
    |> Todo.List.add_entry(%{date: {2017, 05, 14}, title: "Death Star"})
    |> Todo.List.add_entry(%{date: {2017, 05, 15}, title: "World domination"})
    |> Todo.List.add_entry(%{date: {2017, 05, 15}, title: "Retirement"})
  end

  def world_domination(todo_list \\ sample_todo_list()) do
    todo_list
    |> Todo.List.entries({2017, 05, 15})
    |> Enum.at(0)
  end
end
