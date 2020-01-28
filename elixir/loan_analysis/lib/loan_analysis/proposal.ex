defmodule LoanAnalysis.Proposal do
  alias LoanAnalysis.{Event, ProposalsStore, Warranty, Proponent, Proposal}

  defstruct(
    id: "",
    loan_value: 0,
    number_of_monthly_installments: 0,
    warranties: %{},
    proponents: %{}
  )

  def validate(proposal_id) do
    proposal_id
    |> ProposalsStore.get()
    |> do_validate()
  end

  defp do_validate(proposal = %Proposal{}) do
    # O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
    # O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos

    if proposal.loan_value > 30000 && proposal.loan_value < 3_000_000 &&
         proposal.number_of_monthly_installments >= 24 &&
         proposal.number_of_monthly_installments <= 180 &&
         Warranty.validate(Map.values(proposal.warranties), proposal.loan_value) == :ok &&
         Proponent.validate(
           Map.values(proposal.proponents),
           proposal.loan_value / proposal.number_of_monthly_installments
         ) == :ok do
      :ok
    else
      {:error, "proposal invalid"}
    end
  end

  def build(event = %Event{schema: "proposal", action: "created"}) do
    proposal_data = event.data
    [id | proposal_data] = proposal_data
    [loan_value | proposal_data] = proposal_data
    [number_of_monthly_installments | _proposal_data] = proposal_data

    %Proposal{
      id: id,
      loan_value: String.to_float(loan_value),
      number_of_monthly_installments: String.to_integer(number_of_monthly_installments)
    }
  end

  def add_warranty(event = %Event{schema: "warranty"}) do
    warranty = Warranty.build(event)

    proposal = ProposalsStore.get(warranty.proposal_id)
    %{proposal | warranties: Map.put(proposal.warranties, warranty.id, warranty)}
  end

  def remove_warranty(event = %Event{schema: "warranty"}) do
    data = event.data
    [proposal_id | data] = data
    [warranty_id | _data] = data

    proposal = ProposalsStore.get(proposal_id)
    %{proposal | warranties: Map.pop(proposal.warranties, warranty_id)}
  end

  def add_proponent(event = %Event{schema: "proponent"}) do
    proponent = Proponent.build(event)

    proposal = ProposalsStore.get(proponent.proposal_id)
    %{proposal | proponents: Map.put(proposal.proponents, proponent.id, proponent)}
  end

  def remove_proponent(event = %Event{schema: "proponent"}) do
    data = event.data
    [proposal_id | data] = data
    [proponent_id | _data] = data

    proposal = ProposalsStore.get(proposal_id)
    %{proposal | proponents: Map.pop(proposal.proponents, proponent_id)}
  end
end
