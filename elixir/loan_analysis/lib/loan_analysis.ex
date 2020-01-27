defmodule LoanAnalysis do

  alias LoanAnalysis.{Event, Proposal, Proposals, Warranty, Proponent}

  def start() do
    Proposals.start_link()
  end

  def read_file(file) do
    File.read!(file)
      |> String.split("\n")
  end

  def parse_event(message) do
    message_data = String.split(message, ~r{,})
    [id | message_data] = message_data
    [schema | message_data] = message_data
    [action | message_data] = message_data
    [timestamp | message_data] = message_data

    %Event{
      id: id,
      schema: schema,
      action: action,
      timestamp: timestamp,
      data: message_data,
    }
  end

  # def validate_event(event) do
  #   # Em caso de eventos repetidos, considere o primeiro evento
  #   #     Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
  #   # Em caso de eventos atrasados, considere sempre o evento mais novo
  #   #     Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
  # end

  def process_event(event = %Event{schema: "proposal", action: "created"}) do
    proposal_data = event.data
    [id | proposal_data] = proposal_data
    [loan_value | proposal_data] = proposal_data
    [number_of_monthly_installments | _proposal_data] = proposal_data

    proposal = %Proposal{
      id: id,
      loan_value: String.to_float(loan_value),
      number_of_monthly_installments: String.to_integer(number_of_monthly_installments),
    }
    Proposals.upsert(proposal)
    proposal
  end

  def process_event(event = %Event{schema: "warranty", action: "added"}), do: warranty_upsert(event)
  def process_event(event = %Event{schema: "warranty", action: "updated"}), do: warranty_upsert(event)

  def process_event(event = %Event{schema: "proponent", action: "added"}), do: proponent_upsert(event)
  def process_event(event = %Event{schema: "proponent", action: "updated"}), do: proponent_upsert(event)

  defp warranty_upsert(event = %Event{schema: "warranty"}) do
    warranty_data = event.data
    [proposal_id | warranty_data] = warranty_data
    [id | warranty_data] = warranty_data
    [value | warranty_data] = warranty_data
    [province | _warranty_data] = warranty_data

    proposal = Proposals.get(proposal_id)

    warranty = %Warranty{
      id: id,
      value: String.to_float(value),
      province: province,
    }

    %{proposal | warranties: Map.put(proposal.warranties, warranty.id, warranty)}
    |> Proposals.upsert()
    warranty
  end

  defp proponent_upsert(event = %Event{schema: "proponent"}) do
    proponent_data = event.data
    [proposal_id | proponent_data] = proponent_data
    [id | proponent_data] = proponent_data
    [name | proponent_data] = proponent_data
    [age | proponent_data] = proponent_data
    [monthly_income | proponent_data] = proponent_data
    [is_main | _proponent_data] = proponent_data

    proposal = Proposals.get(proposal_id)

    proponent = %Proponent{
      proposal_id: proposal_id,
      id: id,
      name: name,
      age: String.to_integer(age),
      monthly_income: String.to_float(monthly_income),
      is_main: String.to_atom(is_main),
    }

    %{proposal | proponents: Map.put(proposal.proponents, proponent.id, proponent)}
    |> Proposals.upsert()
    proponent
  end

  def validate_proposal(proposal_id) do
    Proposals.get(proposal_id)
    |> valid
  end

  def valid(proposal = %Proposal{}) do

    IO.inspect(proposal)
    # O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
    # O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos

    if proposal.loan_value > 30000 && proposal.loan_value < 3000000
    && proposal.number_of_monthly_installments >= 24 && proposal.number_of_monthly_installments <= 180
    && valid_warranties(Map.values(proposal.warranties), proposal.loan_value)
    && valid_proponents(Map.values(proposal.proponents), proposal.loan_value)
    do
      :ok
    else
      {:error, "proposal invalid"}
    end
  end

  def valid_warranties(proposal_warranties, loan_value) do
    # As garantias de imóvel dos estados PR, SC e RS não são aceitas
    if Enum.count(Enum.filter(proposal_warranties, fn warranty -> !Enum.member?(["PR", "SC", "RS"], warranty.province) end)) == 0
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

  def valid_proponents(proposal_proponents, loan_installment_value) do
    main_proponents = Enum.filter(proposal_proponents, fn proponent -> proponent.is_main end)

    # Deve haver no mínimo 2 proponentes por proposta
    if Enum.count(proposal_proponents) >= 2
    # Deve haver exatamente 1 proponente principal por proposta
    && Enum.count(main_proponents) == 1
    # Todos os proponentes devem ser maiores de 18 anos
    && Enum.filter(proposal_proponents, fn proponent -> proponent.age >= 18 end)
    do
      # A renda do proponente principal deve ser pelo menos:
      #     4 vezes o valor da parcela do empréstimo, se a idade dele for entre 18 e 24 anos
      #     3 vezes o valor da parcela do empréstimo, se a idade dele for entre 24 e 50 anos
      #     2 vezes o valor da parcela do empréstimo, se a idade dele for acima de 50 anos
      main_proponent = hd(main_proponents)
      minimal_income =
        cond do
          main_proponent.age >= 18 && main_proponent.age < 24 ->
            4 * loan_installment_value
          main_proponent.age >=24  && main_proponent.age < 50 ->
            3 * loan_installment_value
          main_proponent.age >= 50 ->
            2 * loan_installment_value
      end
      if main_proponent.monthly_income >= minimal_income do
        :ok
      end
    end
    {:error, "invalid proponents"}
  end

  defp sum_values([], sum) do
    sum
  end
  defp sum_values(warranties, sum) do
    [warranty | warranties] = warranties
    sum_values(warranties, warranty.value + sum)
  end

  defp sum_values(warranties) do
    [warranty | warranties] = warranties
    sum_values(warranties, warranty.value)
  end
end
