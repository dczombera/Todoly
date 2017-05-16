defmodule WebTest do
  use ExUnit.Case, async: false

  # A pretty hacky approach. :P 
  setup do
    {:ok, apps} = Application.ensure_all_started(:todo)
    HTTPoison.start

    on_exit fn ->
      File.rm_rf("./persist/")
      Enum.each(apps, &Application.stop/1)
    end

    :ok
  end

  test "http server" do
    assert {:ok, %HTTPoison.Response{body: "", status_code: 200}} = 
      HTTPoison.get("http://127.0.0.1:1337/entries?list=world_domination&date=20170515")

    assert {:ok, %HTTPoison.Response{body: "OK", status_code: 200}} = 
      HTTPoison.post("http://127.0.0.1:1337/add_entry?list=master_plan&date=20170515&title=world_domination", "")

    assert {:ok, %HTTPoison.Response{body: "2017-5-15   world_domination", status_code: 200}} = 
      HTTPoison.get("http://127.0.0.1:1337/entries?list=master_plan&date=20170515")
  end
end
