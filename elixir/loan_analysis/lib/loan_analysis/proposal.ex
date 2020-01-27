defmodule LoanAnalysis.Proposal do
  defstruct(
    id: "",
    loan_value: 0,
    number_of_monthly_installments: 0,
    warranties: %{},
    proponents: %{}
  )
end
