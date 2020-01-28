defmodule LoanAnalysis.Warranty do
  defstruct(
      id: "",
      value: 0,
      province: "",
      # warranties: [],
      # proponents: []
  )

  def validate([], loan_value), do: {:error, "no warranties"}

  def validate(proposal_warranties, loan_value) do
    # As garantias de imóvel dos estados PR, SC e RS não são aceitas
    if Enum.count(Enum.filter(proposal_warranties, fn warranty -> Enum.member?(["PR", "SC", "RS"], warranty.province) end)) == 0
    # Dever haver no mínimo 1 garantia de imóvel por proposta
    && Enum.count(proposal_warranties) >= 1
    # A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo
    && sum_values(proposal_warranties) >= 2 * loan_value
    do
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
