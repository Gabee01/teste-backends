defmodule LoanAnalysis.Worker do
  use GenServer
  alias LoanAnalysis.{Event, ProposalsStore, EventsStore, Proposal}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    do_work()
    {:ok, nil}
  end

  def do_work() do
    Path.wildcard("../../test/input/*.txt")
    |> read_files
  end

  def read_files(_ = []) do
    {:ok, "no more files to read"}
  end

  def read_files(files) do
    ProposalsStore.start_link
    EventsStore.start_link
    [file | files] = files
    file
    |> File.read!()
    |> String.split("\n")
    |> Event.process

    proposals = ProposalsStore.all()

    valid_proposals = Map.values(proposals)
    |> Enum.filter(fn proposal -> Proposal.validate?(proposal) == {:ok, true} end)
    |> Enum.reduce([], fn (prop, acc) -> [prop.id | acc] end)

    compare_results(valid_proposals, String.replace(file, "input", "output"))

    ProposalsStore.clear()
    EventsStore.clear()
    read_files(files)
  end

  def compare_results(valid_proposals, expected_output_file) do
    IO.puts(expected_output_file)
    expected_output = expected_output_file
    |> File.read!()
    |> String.split(",")
    |> Enum.sort()

    (Enum.sort(valid_proposals) == expected_output)
    |> IO.inspect()
  end
end
