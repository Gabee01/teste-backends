using System.Collections.Generic;
using System.Linq;

namespace csharp.Proposal
{
  public class Proposal
  {
    public Proposal(string[] proposalParams)
    {
      Id = proposalParams[0];
      LoanValue = decimal.Parse(proposalParams[1]);
      Installments = int.Parse(proposalParams[2]);
      Proponents = new List<Proponent>();
      Warranties = new List<Warranty>();
    }

    public string Id { get; set; }

    //proposal_loan_value

    public decimal LoanValue { get; set; }

    // proposal_number_of_monthly_installments

    public int Installments { get; set; }

    public decimal InstallmentValue => LoanValue / Installments;

    public List<Warranty> Warranties { get; set; }

    public List<Proponent> Proponents { get; set; }

    public Proposal Update(string[] proposalParams)
    {
      Id = proposalParams[0];
      LoanValue = decimal.Parse(proposalParams[1]);
      Installments = int.Parse(proposalParams[2]);
      
      return this;
    }

    public void AddWarranty(string[] currentEventPayload)
    {
      Warranties.Add(new Warranty(currentEventPayload));
    }
    
    public void RemoveWarranty(string[] currentEventPayload)
    {
      var toRemoveWarrantyId = currentEventPayload[1];
      Warranties = Warranties.Where(warranty => warranty.Id != toRemoveWarrantyId).ToList();
    }

    public void UpdateWarranty(string[] currentEventPayload)
    {
      var warrantyId = currentEventPayload[1];
      var warrantyIndex = Warranties.FindIndex(proposal => proposal.Id == warrantyId);

      Warranties[warrantyIndex] = new Warranty(currentEventPayload);
    }

    public void AddProponent(string[] currentEventPayload)
    {
      Proponents.Add(new Proponent(currentEventPayload));
    }

    public void UpdateProponent(string[] currentEventPayload)
    {
      var proponentId = currentEventPayload[1];
      var proponentIndex = Warranties.FindIndex(proposal => proposal.Id == proponentId);

      Proponents[proponentIndex] = new Proponent(currentEventPayload);
    }

    public void RemoveProponent(string[] currentEventPayload)
    {
      var toRemoveProponentId = currentEventPayload[1];
      Proponents = Proponents.Where(proponent => proponent.Id != toRemoveProponentId).ToList();
    }
  }
}
