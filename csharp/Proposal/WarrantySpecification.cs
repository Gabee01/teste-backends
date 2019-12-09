using System.Linq;

namespace csharp.Proposal
{
  public static class WarrantySpecification
  {
    
    //    As garantias de imóvel dos estados PR, SC e RS não são aceitas
    public static bool IsProvinceAcceptable(Warranty warranty)
    {
      var invalidStates = new []
      {
        "PR",
        "SC",
        "RS"
      };
      
      return !invalidStates.Contains(warranty.Province);
    }

    //    A soma do valor das garantias deve ser maior ou igual ao dobro do valor do empréstimo
    public static bool HasCompatibleValue(Proposal proposal)
    {
      return proposal.Warranties.Sum(warranty => warranty.Value) >= proposal.LoanValue * 2;
    }

    //    Dever haver no mínimo 1 garantia de imóvel por proposta
    public static bool HasAtLeastOne(Proposal proposal)
    {
      return proposal.Warranties.Count > 1;
    }
  }
}
