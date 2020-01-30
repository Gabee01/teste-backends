defmodule LoanAnalysis.Proposal.ProposalValidationWorker do
  use GenServer
  alias LoanAnalysis.Proposal.{ProposalsStore, Proposal}

  def validate() do
    GenServer.call(__MODULE__, {:validate, ProposalsStore.all()})
  end

  def test(expected_output_file) do
    GenServer.call(__MODULE__, {:validate_and_compare, ProposalsStore.all(), expected_output_file})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    ProposalsStore.start_link()
    {:ok, ProposalsStore.all()}
  end

  def handle_call({:validate, proposals}, _from, _state) do
    valid_proposals = Proposal.get_valids(proposals)
    IO.inspect valid_proposals, label: "Valid proposals"

    ProposalsStore.clear()
    {:reply, self(), valid_proposals}
  end

  def handle_call({:validate_and_compare, proposals, expected_output_file}, _from, state) do
    expected_output = expected_output_file
    |> File.read!()
    |> String.split(",")
    |> Enum.sort()

    valid_proposals = Proposal.get_valids(proposals)

    (Enum.sort(valid_proposals) == expected_output)
    |> IO.inspect(label: "Test result (true = passed)")

    ProposalsStore.clear()
    {:reply, self(), state}
  end
end
