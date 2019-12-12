using System;

namespace csharp.Proposal
{
  public static class ProposalSpecification
  {
    public static bool IsValid(Proposal proposal)
    {
      return
        HasValidLoanValue(proposal) &&
        HasValidInstallments(proposal) &&
        HasValidWarranties(proposal) &&
        HasValidProponents(proposal);
    }

    //    O valor do empréstimo deve estar entre R$ 30.000,00 e R$ 3.000.000,00
    public static bool HasValidLoanValue(Proposal proposal)
    {
      return proposal.LoanValue >= 30000 && proposal.LoanValue <= 3000000;
    }
    
    //    O empréstimo deve ser pago em no mínimo 2 anos e no máximo 15 anos
    public static bool HasValidInstallments(Proposal proposal)
    {
      return proposal.Installments >= 2 * 12 && proposal.Installments <= 15 * 12;
    }

    public static bool HasValidProponents(Proposal proposal)
    {
      foreach (var proponent in proposal.Proponents)
      {
        if (!ProponentSpecification.HasCompatibleIncome(proponent, proposal.InstallmentValue))
          return false;
//          throw new Exception("Proposal has proponent with incompatible income");
      }

      return ProponentSpecification.HasAtLeastTwo(proposal) &&
             ProponentSpecification.HasSingleMain(proposal) &&
             ProponentSpecification.AreAllOverEighteen(proposal);

    }

    public static bool HasValidWarranties(Proposal proposal)
    {
      foreach (var warranty in proposal.Warranties)
      {
        if (!WarrantySpecification.IsProvinceAcceptable(warranty))
          return false;
//          throw new Exception("Proposal has warranty with invalid state");
      }

      return WarrantySpecification.HasCompatibleValue(proposal) && WarrantySpecification.HasAtLeastOne(proposal);
    }
  }
}
