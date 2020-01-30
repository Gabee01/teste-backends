defmodule LoanAnalysis.Proposal.ProposalsStore do
  alias LoanAnalysis.Proposal.Proposal
  use Agent

  @me __MODULE__

  def start_link() do
    Agent.start_link(fn -> %{} end, name: @me)
  end

  def get(id) do
    Agent.get(@me, &Map.get(&1, id))
  end

  def put(proposal = %Proposal{}) do
    Agent.update(@me, &Map.put(&1, proposal.id, proposal))
    proposal
  end

  def delete(id) do
    Agent.get_and_update(@me, fn state ->
      {_removed, new_map} = Map.pop(state, id)
      new_map
    end)
  end

  def all() do
    Agent.get(@me, fn proposal -> proposal end)
  end

  def clear() do
    Agent.update(@me, fn _state -> %{} end)
  end
end
