defmodule LoanAnalysisTest do
  use ExUnit.Case
  doctest LoanAnalysis

  alias LoanAnalysis.{Event, Proposal, Proposals}

  test "messages read from file" do
    assert 20 == (
      LoanAnalysis.read_file("../../test/input/input001.txt")
      |> length)
  end

  test "messages parsed into events" do
    LoanAnalysis.read_file("../../test/input/input001.txt")
    |> Enum.each(
      fn(line) ->
        assert %Event{} = LoanAnalysis.parse_event(line)
    end)
  end

  test "proposal is created and stored on agent" do
    LoanAnalysis.start()
    proposal = "b0f68661-3937-4b94-8cb8-b7f5878f368e,proposal,created,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,1656233.0,108"
      |> LoanAnalysis.parse_event()
      |> LoanAnalysis.process_event()
    assert %Proposal{} = Proposals.get("901557cb-01b5-4747-ad73-5d1e53d16bac")
  end

  test "added warranty to proposal" do
    LoanAnalysis.start()
    proposal = "b0f68661-3937-4b94-8cb8-b7f5878f368e,proposal,created,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,1656233.0,108"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "32fdacb9-692f-452c-b5b7-cea085deeebe,warranty,added,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,04a3e08b-9f2d-4867-90f4-d7ae76d5868c,4741508.96,ES"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    assert  Proposals.get("901557cb-01b5-4747-ad73-5d1e53d16bac").warranties != []
  end

  test "proposal's warranty updated" do
    LoanAnalysis.start()
    proposal = "b0f68661-3937-4b94-8cb8-b7f5878f368e,proposal,created,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,1656233.0,108"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "32fdacb9-692f-452c-b5b7-cea085deeebe,warranty,added,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,04a3e08b-9f2d-4867-90f4-d7ae76d5868c,4741508.96,ES"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    warranty = "32fdacb9-692f-452c-b5b7-cea085deeebe,warranty,updated,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,04a3e08b-9f2d-4867-90f4-d7ae76d5868c,4741508.96,PR"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

      assert warranty == Map.get(Proposals.get("901557cb-01b5-4747-ad73-5d1e53d16bac").warranties, "04a3e08b-9f2d-4867-90f4-d7ae76d5868c")
  end

  test "added proponent to proposal" do
    LoanAnalysis.start()
    "b0f68661-3937-4b94-8cb8-b7f5878f368e,proposal,created,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,1656233.0,108"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "07158053-fcb6-40bf-bfb7-3184a8881a68,proponent,added,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,9a4f6388-f937-4da5-8293-6b2dac7d7afb,Page Breitenberg,35,126096.68,true"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    assert Proposals.get("901557cb-01b5-4747-ad73-5d1e53d16bac").proponents != []
  end

  test "proposal's proponent updated" do
    LoanAnalysis.start()
    "b0f68661-3937-4b94-8cb8-b7f5878f368e,proposal,created,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,1656233.0,108"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "07158053-fcb6-40bf-bfb7-3184a8881a68,proponent,added,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,9a4f6388-f937-4da5-8293-6b2dac7d7afb,Page Breitenberg,35,126096.68,true"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    proponent = "07158053-fcb6-40bf-bfb7-3184a8881a68,proponent,updated,2019-11-11T14:29:16Z,901557cb-01b5-4747-ad73-5d1e53d16bac,9a4f6388-f937-4da5-8293-6b2dac7d7afb,John Doe,35,126096.68,true"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    assert proponent == Map.get(Proposals.get("901557cb-01b5-4747-ad73-5d1e53d16bac").proponents, "9a4f6388-f937-4da5-8293-6b2dac7d7afb")
  end

  # test "deleted warranty from proposal" do

  # end

  # test "deleted proponent from proposal" do

  # end

  test "proposal is valid" do
    LoanAnalysis.start()
    "c2d06c4f-e1dc-4b2a-af61-ba15bc6d8610,proposal,created,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,684397.0,72"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "27179730-5a3a-464d-8f1e-a742d00b3dd3,warranty,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,6b5fc3f9-bb6b-4145-9891-c7e71aa87ca2,1967835.53,ES"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "716de46f-9cc0-40be-b665-b0d47841db4c,warranty,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,1750dfe8-fac7-4913-b946-ab538dce0977,1608429.56,GO"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "05588a09-3268-464f-8bc8-03974303332a,proponent,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,5f9b96d2-b8db-48a8-a28b-f7ac9b3c8108,Kip Beer,50,73300.95,true"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "0fe9465f-af17-452c-9abe-fa64d475d8ad,proponent,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,fc1a95db-5468-4a37-9a49-9b15b9e250e6,Dong McDermott,50,67287.16,false"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    assert LoanAnalysis.validate_proposal("bd6abe95-7c44-41a4-92d0-edf4978c9f4e") == :ok
  end

  test "proposal is not valid" do
    LoanAnalysis.start()
    "c2d06c4f-e1dc-4b2a-af61-ba15bc6d8610,proposal,created,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,684397.0,72"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "27179730-5a3a-464d-8f1e-a742d00b3dd3,warranty,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,6b5fc3f9-bb6b-4145-9891-c7e71aa87ca2,1967835.53,ES"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    "716de46f-9cc0-40be-b665-b0d47841db4c,warranty,added,2019-11-11T13:26:04Z,bd6abe95-7c44-41a4-92d0-edf4978c9f4e,1750dfe8-fac7-4913-b946-ab538dce0977,1608429.56,GO"
    |> LoanAnalysis.parse_event()
    |> LoanAnalysis.process_event()

    assert LoanAnalysis.validate_proposal("bd6abe95-7c44-41a4-92d0-edf4978c9f4e") == :error
  end
end
