defmodule LoanAnalysis do
  alias LoanAnalysis.{Event, Proposal, Proposals, Warranty, Proponent, Helper}

  defdelegate init_state(), to: Helper, as: :start
  defdelegate validate_proposal(proposal_id), to: Proposal, as: :validate
end
