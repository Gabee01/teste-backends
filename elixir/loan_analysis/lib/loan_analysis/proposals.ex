defmodule LoanAnalysis.Proposals do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(id) do
    Agent.get(LoanAnalysis.Proposals, &Map.get(&1, id))
  end

  def upsert(proposal) do
    Agent.update(__MODULE__, &Map.put(&1, proposal.id, proposal))
  end

  # def delete(bucket, key) do
  #   Agent.get_and_update(bucket, &Map.pop(&1, key))
  # end
end
