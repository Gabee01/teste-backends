defmodule LoanAnalysis.Event.Event do
  alias LoanAnalysis.Proposal.{ProposalsStore, Proposal}
  alias LoanAnalysis.Event.{Event, EventsStore}

  defstruct(
    id: "",
    schema: "",
    action: "",
    timestamp: "",
    data: []
  )

  def process(message) when is_binary(message) do
    event = build(message)

    if valid?(event) do
      event
      |> EventsStore.put()
      |> do_process()
    end
  end

  def valid?(event) do
    # Em caso de eventos repetidos, considere o primeiro evento
    #     Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
    unless EventsStore.get(event.id) != nil || is_late?(event) do
      true
    else
      false
    end
  end

  defp is_late?(event) do
    # Em caso de eventos atrasados, considere sempre o evento mais novo
    #     Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
    all_events = EventsStore.all()
    unless Enum.empty?(all_events) do
      all_events
      |> Map.values()
      |> Enum.any?(fn e -> e.timestamp > event.timestamp end)
    else
      false
    end
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
      timestamp: DateTime.from_naive!(NaiveDateTime.from_iso8601!(timestamp), "Etc/UTC"),
      data: message_data
    }
  end

  defp do_process(event = %Event{schema: "proposal", action: "created"}) do
    ProposalsStore.put(Proposal.build(event))
  end

  defp do_process(event = %Event{schema: "proposal", action: "deleted"}) do
    [proposal_id | _] = event.data
    ProposalsStore.delete(proposal_id)
  end

  defp do_process(event = %Event{schema: "warranty", action: "added"}) do
    ProposalsStore.put(Proposal.add_warranty(event))
  end

  defp do_process(event = %Event{schema: "warranty", action: "updated"}) do
    ProposalsStore.put(Proposal.add_warranty(event))
  end

  defp do_process(event = %Event{schema: "warranty", action: "removed"}) do
    ProposalsStore.put(Proposal.remove_warranty(event))
  end

  defp do_process(event = %Event{schema: "proponent", action: "added"}) do
    ProposalsStore.put(Proposal.add_proponent(event))
  end

  defp do_process(event = %Event{schema: "proponent", action: "updated"}) do
    ProposalsStore.put(Proposal.add_proponent(event))
  end

  defp do_process(event = %Event{schema: "proponent", action: "removed"}) do
    ProposalsStore.put(Proposal.remove_proponent(event))
  end
end
