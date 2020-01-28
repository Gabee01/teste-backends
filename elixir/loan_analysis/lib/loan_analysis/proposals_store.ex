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

  def delete(id) do
    Agent.get_and_update(__MODULE__, &Map.pop(&1, id))
  end
end
