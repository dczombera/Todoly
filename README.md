# Web Todo App

A small Todo app with an HTTP interface made in in Elixir.
Why would I waste my time creating just another useless Todo app? 
First and foremost to learn more about Elixir, OTP, ETS tables, behaviours and supervision trees.
This app shows how to localize errors and keep unrelated parts of the system running.
It also provied an HTTP interface (using `Cowboy`) to simulate real-world interaction with the application

## Usage 

There are several ways of how to start the application after you cloned it.
One easy way is to start it with `iex -S mix` (from the apps root directory):

```elixir
$ iex -S mix
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Starting database worker 1...
Starting database worker 2...
Starting database worker 3...
Interactive Elixir (1.4.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Now, the app is running and waits to receive HTTP requests. Let's fire a few requests with `curl`: 

```elixir
$ curl -d "" "http://localhost:1337/add_entry?list=master_plan&date=20170504&title=world_domination"
"OK"

$ curl "http://localhost:1337/entries?list=master_plan&date=20170504"
2017-5-4   world_domination

$ curl -d "" "http://localhost:1337/add_entry?list=coding&date=20170101&title=learn_elixir"
"OK"

$ curl "http://localhost:1337/entries?list=coding&date=20170101"
2017-1-1  learn_elixir 
```
Two different todo lists were created holding different titles and dates. 
By the way, the port `1337` is defined as a application environment variable `Application.get_env(:todo, :port)`
You can change it in the config file `config/config.exs` or alternatively from the command line when starting the application `$ iex --erl "-todo port 5454" -S mix`.
In the latter case you use the Erlang option to provide the application environment variable.
Let's have a quick lock at the fine-grained supervision tree of this amazing todo web app:


