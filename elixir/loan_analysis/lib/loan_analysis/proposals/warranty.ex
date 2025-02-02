defmodule LoanAnalysis.Proposal.Warranty do
  alias LoanAnalysis.Proposal.Warranty
  alias LoanAnalysis.Event.Event

  defstruct(
    proposal_id: "",
    id: "",
    value: 0,
    province: ""
  )

  def build(event = %Event{schema: "warranty"}) do
    warranty_data = event.data
    [proposal_id | warranty_data] = warranty_data
    [id | warranty_data] = warranty_data
    [value | warranty_data] = warranty_data
    [province | _warranty_data] = warranty_data

    %Warranty{
      proposal_id: proposal_id,
      id: id,
      value: String.to_float(value),
      province: province
    }
  end

  def validate([], _), do: {:error, "no warranties"}

  def validate(proposal_warranties, loan_value) do
    # As garantias de imóvel dos estados PR, SC e RS não são aceitas
    # Dever haver no mínimo 1 garantia de imóvel por proposta
    # A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo
    if Enum.empty?(
         Enum.filter(proposal_warranties, fn warranty ->
           Enum.member?(["PR", "SC", "RS"], warranty.province)
         end)
       ) && Enum.count(proposal_warranties) >= 1 &&
         sum_values(proposal_warranties) >= 2 * loan_value do
      :ok
    else
      {:error, "invalid warranties"}
    end
  end

  def sum_values([], sum) do
    sum
  end

  def sum_values(warranties, sum) do
    [warranty | warranties] = warranties
    sum_values(warranties, warranty.value + sum)
  end

  def sum_values(warranties) do
    [warranty | warranties] = warranties
    sum_values(warranties, warranty.value)
  end
end
