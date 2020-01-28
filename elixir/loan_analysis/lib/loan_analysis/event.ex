defmodule LoanAnalysis.Event do
  alias LoanAnalysis.{Proposal, Proposals, Warranty, Proponent, Helper, Event}

  defstruct(
    id: "",
    schema: "",
    action: "",
    timestamp: "",
    data: [],
  )

  # def validate_event(event) do
  #   # Em caso de eventos repetidos, considere o primeiro evento
  #   #     Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
  #   # Em caso de eventos atrasados, considere sempre o evento mais novo
  #   #     Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
  # end

  def process(event = %Event{schema: "proposal", action: "created"}) do
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

  def process(event = %Event{schema: "warranty", action: "added"}), do: warranty_upsert(event)
  def process(event = %Event{schema: "warranty", action: "updated"}), do: warranty_upsert(event)

  def process(event = %Event{schema: "proponent", action: "added"}), do: proponent_upsert(event)
  def process(event = %Event{schema: "proponent", action: "updated"}), do: proponent_upsert(event)

  def process(message) do
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
    |> process
  end

  def warranty_upsert(event = %Event{schema: "warranty"}) do
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

  def proponent_upsert(event = %Event{schema: "proponent"}) do
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
end
