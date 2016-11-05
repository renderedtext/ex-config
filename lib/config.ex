defmodule Config do
  @moduledoc """
  Module for fetching values from the application's config or from the
  environment if {:system, "VAR"} is provided.
  """

  @doc """
  Fetches valau and and return's either {:ok, value} or {:error, nil}

  ## Reads value from the application's config
    iex> Application.put_env(:my_app, :foo, "bar")
    iex> Config.get(:my_app, :foo)
    {:ok, "bar"}

  ## Reads value from the system's environment
    iex> System.put_env("BAZ", "bar")
    iex> Application.put_env(:my_app, :baz, {:system, "BAZ"})
    iex> Config.get(:my_app, :baz)
    {:ok, "bar"}

  ## When the value is not present in tha application's configuration.
    iex> Config.get(:my_app, :non_existing_foo)
    {:error, nil}
  """
  @spec get(atom, atom) :: term
  def get(app, key) when is_atom(app) and is_atom(key) do
    case Application.get_env(app, key) do
      {:system, env_var} ->
        case System.get_env(env_var) do
          nil -> {:error, nil}
          val -> {:ok, val}
        end
      nil ->
        {:error, nil}
      val ->
        {:ok, val}
    end
  end


  @doc """
  Fetches value with a provided default value

    iex> Config.get(:my_app, :non_existing_foo, default: "BAAAR")
    {:ok, "BAAAR"}
  """
  @spec get(atom, atom, default: term) :: term
  def get(app, key, default: default_value) do
    case get(app, key) do
      {:ok, value} -> {:ok, value}
      {:error, _}  -> {:ok, default_value}
    end
  end


  @doc """
  Fetches a value or raises an exception if it is not provided.

    iex> Application.put_env(:my_app, :foo, "bar")
    iex> Config.get!(:my_app, :foo)
    "bar"
  """
  def get!(app, key) do
    case get(app, key) do
      {:ok, value} -> value
      {:error, _}  ->
        raise "Configuration for application #{app} for #{key} is not missing"
    end
  end


  @doc """
  Fetches a value or raises an exception if it is not provided.

    iex> Config.get!(:my_app, :foo, default: "bar")
    "bar"
  """
  def get!(app, key, default: default_value) do
    case get(app, key) do
      {:ok, value} -> value
      {:error, _}  -> default_value
    end
  end
end
