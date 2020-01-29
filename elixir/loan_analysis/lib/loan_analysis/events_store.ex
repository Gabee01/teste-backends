defmodule LoanAnalysis.EventsStore do
  alias LoanAnalysis.Event
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(id) when is_binary(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def put(event = %Event{}) do
    Agent.update(__MODULE__, &Map.put(&1, event.id, event))
    event
  end

  def all() do
    Agent.get(__MODULE__, fn proposal -> proposal end)
  end

  def clear() do
    Agent.update(__MODULE__, fn state -> %{} end)
  end

  # def delete(bucket, key) do
  #   Agent.get_and_update(bucket, &Map.pop(&1, key))
  # end
end
