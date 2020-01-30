defmodule LoanAnalysis.Event.EventWorker do
  use GenServer
  alias LoanAnalysis.Event.{Event, EventsStore}
  alias LoanAnalysis.Proposal.{ProposalsStore, ProposalValidationWorker}

  def process_all_files() do
    "../../test/input/*.txt"
    |> Path.wildcard()
    |> Enum.each(fn file ->
      process(file)
      EventsStore.clear()
    end)
  end

  def process(file) when is_binary(file) do
    GenServer.call(__MODULE__, {:process_file, file})
    ProposalValidationWorker.validate()
  end

  def test_all_files() do
    "../../test/input/*.txt"
    |> Path.wildcard()
    |> Enum.each(fn file ->
      test(file)
      EventsStore.clear()
    end)
  end

  def test(file) when is_binary(file) do
    GenServer.call(__MODULE__, {:process_file, file})
    output_file = String.replace(file, "input", "output")
    ProposalValidationWorker.test(output_file)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    ProposalsStore.start_link()
    EventsStore.start_link()

    {:ok, EventsStore.all()}
  end

  def handle_call({:process_file, file}, _from, _state) do
    IO.puts("Reading file #{ file }")
    file
    |> File.read!()
    |> String.split("\n")
    |> Enum.each(fn message -> Event.process(message) end)

    {:reply, self(), EventsStore.all}
  end
end
