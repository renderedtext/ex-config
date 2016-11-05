# Config

Fetch configuration values from the application's configuration or
from the environment if it is provided.

Based on [@bitwalker's gist](https://gist.github.com/bitwalker/a4f73b33aea43951fe19b242d06da7b9).

## Installation

``` elixir
def deps do
  [
    {:config, github: "renderedtext/ex-config"}
  ]
end
```

## Usage

Fetch configuration values:

``` elixir
case Config.get(:my_app, :foo) do
  {:ok, value} -> IO.puts value
  {:error, _}  -> IO.puts "Configuration value not set"
end
```

Providing a default value:

``` elixir
{:ok, value} = Config.get(:my_app, :foo, default: "bar")
```

Use the `Config.get!` to raise an exception if the variable is not provided:

``` elixir
value = Config.get!(:my_app, :foo)
```

To fetch an integer:

``` elixir
{:ok, value} = Config.get_integer(:my_app, :foo)

# with default value
{:ok, value} = Config.get_integer(:my_app, :foo, 3)

# raise exception
value = Config.get_integer!(:my_app, :foo)
```

To fetch a boolean:

``` elixir
{:ok, value} = Config.get_boolean(:my_app, :foo)

# with default value
{:ok, value} = Config.get_boolean(:my_app, :foo, true)

# raise exception
value = Config.get_boolean!(:my_app, :foo)
```
