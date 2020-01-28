defmodule LoanAnalysis.Event do
  alias LoanAnalysis.{Proposal, ProposalsStore, Event}

  defstruct(
    id: "",
    schema: "",
    action: "",
    timestamp: "",
    data: []
  )

  # def validate_event(event) do
  #   # Em caso de eventos repetidos, considere o primeiro evento
  #   #     Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
  #   # Em caso de eventos atrasados, considere sempre o evento mais novo
  #   #     Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
  # end

  def process(event = %Event{schema: "proposal", action: "created"}) do
    ProposalsStore.put(Proposal.build(event))
  end

  def process(event = %Event{schema: "proposal", action: "deleted"}) do
    [proposal_id | _] = event.data
    ProposalsStore.delete(proposal_id)
  end

  def process(event = %Event{schema: "warranty", action: "added"}) do
    ProposalsStore.put(Proposal.add_warranty(event))
  end

  def process(event = %Event{schema: "warranty", action: "updated"}) do
    ProposalsStore.put(Proposal.add_warranty(event))
  end

  def process(event = %Event{schema: "warranty", action: "removed"}) do
    ProposalsStore.put(Proposal.remove_warranty(event))
  end

  def process(event = %Event{schema: "proponent", action: "added"}) do
    ProposalsStore.put(Proposal.add_proponent(event))
  end

  def process(event = %Event{schema: "proponent", action: "updated"}) do
    ProposalsStore.put(Proposal.add_proponent(event))
  end

  def process(event = %Event{schema: "proponent", action: "removed"}) do
    ProposalsStore.put(Proposal.remove_proponent(event))
  end

  def process(message) do
    message
    |> build()
    # |> EventsStore.put()
    |> process()
  end

  defp build(message) when is_binary(message) do
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
      data: message_data
    }
  end
end
