defmodule LoanAnalysis.Proponent do
  alias LoanAnalysis.{Event, Proponent}

  defstruct(
    proposal_id: "",
    id: "",
    name: "",
    age: 0,
    monthly_income: 0.0,
    is_main: false
  )

  def build(event = %Event{schema: "proponent"}) do
    proponent_data = event.data
    [proposal_id | proponent_data] = proponent_data
    [id | proponent_data] = proponent_data
    [name | proponent_data] = proponent_data
    [age | proponent_data] = proponent_data
    [monthly_income | proponent_data] = proponent_data
    [is_main | _proponent_data] = proponent_data

    %Proponent{
      proposal_id: proposal_id,
      id: id,
      name: name,
      age: String.to_integer(age),
      monthly_income: String.to_float(monthly_income),
      is_main: String.to_atom(is_main)
    }
  end

  def validate([], _loan_installment_value) do
    {:error, "no proponents"}
  end

  def validate(proposal_proponents, loan_installment_value) do
    main_proponents = Enum.filter(proposal_proponents, fn proponent -> proponent.is_main end)

    # Deve haver no mínimo 2 proponentes por proposta
    # Deve haver exatamente 1 proponente principal por proposta
    # Todos os proponentes devem ser maiores de 18 anos
    if Enum.count(proposal_proponents) >= 2 && Enum.count(main_proponents) == 1 &&
         Enum.count(Enum.filter(proposal_proponents, fn proponent -> proponent.age < 18 end)) == 0 do
      # A renda do proponente principal deve ser pelo menos:
      #     4 vezes o valor da parcela do empréstimo, se a idade dele for entre 18 e 24 anos
      #     3 vezes o valor da parcela do empréstimo, se a idade dele for entre 24 e 50 anos
      #     2 vezes o valor da parcela do empréstimo, se a idade dele for acima de 50 anos
      main_proponent = hd(main_proponents)

      minimal_income =
        cond do
          main_proponent.age >= 18 && main_proponent.age < 24 ->
            4 * loan_installment_value

          main_proponent.age >= 24 && main_proponent.age < 50 ->
            3 * loan_installment_value

          main_proponent.age >= 50 ->
            2 * loan_installment_value
        end

      if main_proponent.monthly_income >= minimal_income do
        :ok
      end
    else
      {:error, "invalid proponents"}
    end
  end
end
