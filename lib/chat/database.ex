defmodule Chat.Database do
    @behaviour Chat.TableBehaviour
    require Record
    alias Chat.Repo
  
    Record.defrecord(:chat, key: nil, value: nil)
  
    def table_name(), do:  :chat
    def table_type(), do: :set
    def table_fields(), do: [:key, :value]
    def table_indexes(), do: []
  
    def get(key) do
      case Repo.read(table_name(), key) do
        {:atomic, [data]} -> chat(data, :value)
        {:atomic, []} -> nil
      end
    end
  
    def set(_key, nil), do: nil
  
    def set(key, value) do
      Repo.write(chat(key: key, value: value))
      value
    end
  
    def remove(key) do
      Repo.delete(table_name(), key)
    end
  
    def clear() do
      Repo.clear(table_name())
    end
  
    def all() do
      table_name()
      |> Repo.all()
      |> case do
        {:atomic, list} ->
          list
          |> Enum.map(&chat(&1, :value))
  
        _ ->
          []
      end
    end
  
    def filter(pattern) do
      table_name()
      |> Repo.filter({table_name(), pattern, :_})
      |> case do
        {:atomic, list} ->
          list
          |> Enum.map(&chat(&1, :value))
  
        _ ->
          []
      end
    end
  end
  