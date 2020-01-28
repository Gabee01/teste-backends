defmodule LoanAnalysis.Proposal do
  alias LoanAnalysis.{Proposals, Proposal, Warranty, Proponent}

  defstruct(
    id: "",
    loan_value: 0,
    number_of_monthly_installments: 0,
    warranties: %{},
    proponents: %{}
  )

  def validate(proposal_id) do
    Proposals.get(proposal_id)
    |> valid
  end

  def valid(proposal = %Proposal{}) do
    IO.inspect(proposal)
    # O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
    # O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos

    if proposal.loan_value > 30000 && proposal.loan_value < 3000000
    && proposal.number_of_monthly_installments >= 24 && proposal.number_of_monthly_installments <= 180
    && Warranty.validate(Map.values(proposal.warranties), proposal.loan_value) == :ok
    && Proponent.validate(Map.values(proposal.proponents), proposal.loan_value/proposal.number_of_monthly_installments) == :ok
    do
      :ok
    else
      {:error, "proposal invalid"}
    end
  end
end
