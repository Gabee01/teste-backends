defmodule LoanAnalysis do
  alias LoanAnalysis.Proposal

  defdelegate validate_proposal(proposal_id), to: Proposal, as: :validate
end
