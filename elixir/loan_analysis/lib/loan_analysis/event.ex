defmodule LoanAnalysis.Event do
  alias LoanAnalysis.{Proposal, ProposalsStore, Event, EventsStore}

  defstruct(
    id: "",
    schema: "",
    action: "",
    timestamp: "",
    data: []
  )

  def validate_event?(event) do
    # Em caso de eventos repetidos, considere o primeiro evento
    #     Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
    # Em caso de eventos atrasados, considere sempre o evento mais novo
    #     Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
    all_events = EventsStore.all()
    unless EventsStore.get(event.id) != nil || is_late?(event) do
      true
    else
      IO.puts("found invalid event, id: #{event.id}")
      false
    end
  end

  defp is_late?(event) do
    all_events = EventsStore.all()
    unless Enum.empty?(all_events) do
      last_event_dt = all_events
      |> Map.values
      |> Enum.sort_by(& &1.timestamp)
      |> Enum.reverse
      |> hd
      |> Map.get(:timestamp)

      all_events
      |> Map.values()
      |> Enum.filter(fn e -> e.timestamp < last_event_dt end)
      |> Enum.empty?()
    end
    false
  end

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

  def process([]) do
  end

  def process(messages) when is_list(messages) do
    [message | messages] = messages
    process(message)
    process(messages)
  end

  def process(message) when is_binary(message) do
    event = build(message)

    if validate_event?(event) do
      EventsStore.put(event)
      |> process()
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
end


# [
#   %{"baa73193-bf00-4e6c-b63b-c037679392e3" =>
#    %LoanAnalysis.Event{
#      action: "created",
#      data: ["525810ca-e45d-4146-900c-b6be6caa3c7b", "472459.0", "72"],
#      id: "baa73193-bf00-4e6c-b63b-c037679392e3",
#      schema: "proposal",
#      timestamp: DateTime.from_naive!(~N<2019-11-11 21:03:12Z>, "Etc/UTC")
#    }},
#    %{"baa73193-bf00-4e6c-b63b-c037679392e4" =>
#    %LoanAnalysis.Event{
#      action: "created",
#      data: ["525810ca-e45d-4146-900c-b6be6caa3c7b", "472459.0", "72"],
#      id: "baa73193-bf00-4e6c-b63b-c037679392e4",
#      schema: "proposal",
#      timestamp: DateTime.from_naive!(~N<2019-11-11 21:13:12Z>, "Etc/UTC")
#    }}
# ]
