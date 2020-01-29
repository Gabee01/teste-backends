defmodule LoanAnalysis.ProposalsStore do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(id) do
    Agent.get(__MODULE__, &Map.get(&1, id))
  end

  def put(proposal) do
    Agent.update(__MODULE__, &Map.put(&1, proposal.id, proposal))
    proposal
  end

  # def delete(id) do
  #   Agent.get_and_update(__MODULE__, fn state ->
  #     {_removed, new_map} = Map.pop(state, id)
  #     new_map
  #   end)
  # end

  def all() do
    Agent.get(__MODULE__, fn proposal -> proposal end)
  end

  def clear() do
    Agent.update(__MODULE__, fn state -> %{} end)
  end
end
