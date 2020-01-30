defmodule LoanAnalysis.Event.EventsStore do
  alias LoanAnalysis.Event.Event
  use Agent

  @me __MODULE__

  def start_link() do
    Agent.start_link(fn -> %{} end, name: @me)
  end

  def get(id) when is_binary(id) do
    Agent.get(@me, &Map.get(&1, id))
  end

  def put(event = %Event{}) do
    Agent.update(@me, &Map.put(&1, event.id, event))
    event
  end

  def all() do
    Agent.get(@me, fn proposal -> proposal end)
  end

  def clear() do
    Agent.update(@me, fn _state -> %{} end)
  end
end
