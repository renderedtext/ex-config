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
        raise "Configuration for application #{app} for #{key} is missing"
    end
  end

  @doc """
  Fetches a value or raises an exception if it is not provided.

    iex> Config.get!(:my_app, :non_existing_foo, default: "bar")
    "bar"
  """
  def get!(app, key, default: default_value) do
    case get(app, key) do
      {:ok, value} -> value
      {:error, _}  -> default_value
    end
  end


  @doc """
  Fetches an integer value from the environment

  ## When the value is an integer
    iex> Application.put_env(:my_app, :foo, 23)
    iex> Config.get_integer(:my_app, :foo)
    {:ok, 23}

  ## When the value is an string that can be converted to an integer
    iex> Application.put_env(:my_app, :foo, "23")
    iex> Config.get_integer(:my_app, :foo)
    {:ok, 23}

  ## When the value is not an integer and can't be converted
    iex> Application.put_env(:my_app, :foo, "not_a_number")
    iex> Config.get_integer(:my_app, :non_existing_foo)
    {:error, nil}
  """
  @spec get_integer(atom, atom) :: term
  def get_integer(app, key) do
    case get(app, key) do
      {:ok, value} ->
        if is_integer(value) do
          {:ok, value}
        else
          case Integer.parse(value) do
            {number, _} -> {:ok, number}
            :error      -> {:error, nil}
          end
        end
      {:error, nil}  ->
        {:error, nil}
    end
  end

  @doc """
  Fetches an integer with a default value

    iex> Config.get_integer(:my_app, :non_existing_foo, default: 17)
    {:ok, 17}
  """
  @spec get_integer(atom, atom, default: term) :: term
  def get_integer(app, key, default: default_value) do
    case get_integer(app, key) do
      {:ok, value} -> {:ok, value}
      {:error, _}  -> {:ok, default_value}
    end
  end

  @doc """
  Fetches an integer or raises an exception

    iex> Application.put_env(:my_app, :foo, 23)
    iex> Config.get_integer!(:my_app, :foo)
    23
  """
  @spec get_integer!(atom, atom) :: term
  def get_integer!(app, key) do
    case get_integer(app, key) do
      {:ok, value} -> value
      {:error, _}  ->
        raise "Configuration for application #{app} for #{key} is missing or it is not an integer"
    end
  end

  @doc """
  Fetches an integer or returns the default value

    iex> Application.put_env(:my_app, :foo, 23)
    iex> Config.get_integer!(:my_app, :foo)
    23
  """
  @spec get_integer!(atom, atom) :: term
  def get_integer!(app, key, default: default_value) do
    case get_integer(app, key) do
      {:ok, value} -> value
      {:error, _}  -> default_value
    end
  end


  @doc """
  Fetches a boolean value from the environment

  ## When the value is an integer
    iex> Application.put_env(:my_app, :foo, true)
    iex> Config.get_boolean(:my_app, :foo)
    {:ok, true}

  ## When the value is an string that can be converted to a boolean
    iex> Application.put_env(:my_app, :foo, "true")
    iex> Config.get_boolean(:my_app, :foo)
    {:ok, true}

  ## When the value is not an integer and can't be converted
    iex> Application.put_env(:my_app, :foo, "23")
    iex> Config.get_boolean(:my_app, :non_existing_foo)
    {:error, nil}
  """
  @spec get_boolean(atom, atom) :: term
  def get_boolean(app, key) do
    case get(app, key) do
      {:ok, value} ->
        if is_boolean(value) do
          {:ok, value}
        else
          case value do
            "true"  -> {:ok, true}
            "false" -> {:ok, false}
            _       -> {:error, nil}
          end
        end
      {:error, nil}  ->
        {:error, nil}
    end
  end

  @doc """
  Fetches a boolean with a default value

    iex> Config.get_boolean(:my_app, :non_existing_foo, default: true)
    {:ok, true}
  """
  @spec get_boolean(atom, atom, default: term) :: term
  def get_boolean(app, key, default: default_value) do
    case get_boolean(app, key) do
      {:ok, value} -> {:ok, value}
      {:error, _}  -> {:ok, default_value}
    end
  end

  @doc """
  Fetches a boolean or raises an exception

    iex> Application.put_env(:my_app, :foo, true)
    iex> Config.get_boolean!(:my_app, :foo)
    true
  """
  @spec get_boolean!(atom, atom) :: term
  def get_boolean!(app, key) do
    case get_boolean(app, key) do
      {:ok, value} -> value
      {:error, _}  ->
        raise "Configuration for application #{app} for #{key} is missing or it is not a boolean"
    end
  end

  @doc """
  Fetches a boolean or returns the default value

    iex> Application.put_env(:my_app, :foo, "true")
    iex> Config.get_boolean!(:my_app, :foo)
    true
  """
  @spec get_boolean!(atom, atom) :: term
  def get_boolean!(app, key, default: default_value) do
    case get_boolean!(app, key) do
      {:ok, value} -> value
      {:error, _}  -> default_value
    end
  end
end
