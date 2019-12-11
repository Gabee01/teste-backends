using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using csharp.Event;
using csharp.Proposal;

namespace csharp
{
  public static class Solution
  {
    public static List<Event.Event> ProcessedEvents;
    public static List<Proposal.Proposal> ReceivedProposals;
    public static List<Proposal.Proposal> ValidProposals;
    
    public static string Solve(string[] inputLines)
    {
      ProcessMessages(inputLines);
      ComputeValid();
      return Solution.FormatOutput();
    }
    
    public static void ProcessMessages(string[] inputLines)
    {
      ProcessedEvents = new List<Event.Event>();
      ReceivedProposals = new List<Proposal.Proposal>();
      ValidProposals = new List<Proposal.Proposal>();
      foreach (var inputLine in inputLines)
      {
        // Parse message
        var data = inputLine.Split(",");
        var currentEvent = new Event.Event(data);
        
        //    Em caso de eventos repetidos, considere o primeiro evento
        //      Por exemplo, ao receber o evento ID 1 e novamente o mesmo evento, descarte o segundo evento
        if (!ProcessedEvents.Select(events => events.id).Contains(currentEvent.id))
        {
          ProcessedEvents.Add(currentEvent);

          ProcessEvent(currentEvent);
        }
      }
    }

    public static string FormatOutput()
    {
      var output = "";
      
      foreach (var proposal in ValidProposals)
      {
        output += proposal.Id + ",";
      }
      
      output.TrimEnd(',');

      return output;
    }

    public static void ComputeValid()
    {
      foreach (var proposal in ReceivedProposals)
      {
        if (ProposalSpecification.IsValid(proposal))
          ValidProposals.Add(proposal);
      }
    }

    private static void ProcessEvent(Event.Event currentEvent)
    {
      var eventProposalId = currentEvent.payload[0];
      var proposalIndex = ReceivedProposals.FindIndex(proposal => proposal.Id == eventProposalId);
      
      if (EventSpecification.isProposalCreated(currentEvent))
        ReceivedProposals.Add(new Proposal.Proposal(currentEvent.payload));
      if (EventSpecification.isProposalUpdated(currentEvent) && !EventSpecification.isOld(ProcessedEvents, currentEvent))
        ReceivedProposals[proposalIndex] = ReceivedProposals[proposalIndex].Update(currentEvent.payload);
      if (EventSpecification.isProposalDeleted(currentEvent))
        ReceivedProposals = ReceivedProposals.Where(proposal => proposal.Id != eventProposalId).ToList();

      if (EventSpecification.isWarrantyAdded(currentEvent))
        ReceivedProposals[proposalIndex].AddWarranty(currentEvent.payload);
      if (EventSpecification.isWarrantyUpdated(currentEvent) && !EventSpecification.isOld(ProcessedEvents, currentEvent))
        ReceivedProposals[proposalIndex].UpdateWarranty(currentEvent.payload);
      if (EventSpecification.isWarrantyRemoved(currentEvent))
        ReceivedProposals.First(proposal => proposal.Id != eventProposalId).RemoveWarranty(currentEvent.payload);

      if (EventSpecification.isProponentAdded(currentEvent))
        ReceivedProposals[proposalIndex].AddProponent(currentEvent.payload);
      if (EventSpecification.isProponentUpdated(currentEvent) && !EventSpecification.isOld(ProcessedEvents, currentEvent))
        ReceivedProposals[proposalIndex].UpdateProponent(currentEvent.payload);
      if (EventSpecification.isProponentRemoved(currentEvent))
        ReceivedProposals[proposalIndex].RemoveProponent(currentEvent.payload);
    }
  }
}
