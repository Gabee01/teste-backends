using System;
using System.Linq;

namespace csharp.Proposal
{
  public static class ProponentSpecification
  {
    
    //    Deve haver no mínimo 2 proponentes por proposta
    public static bool HasAtLeastTwo(Proposal proposal)
    {
      return proposal.Proponents.Count >= 2;
    }

    //    Deve haver exatamente 1 proponente principal por proposta
    public static bool HasSingleMain(Proposal proposal)
    {
      return proposal.Proponents.Count(proponent => proponent.IsMainProponent) == 1;
    }
    
    //    Todos os proponentes devem ser maiores de 18 anos
    public static bool AreAllOverEighteen(Proposal proposal)
    {
      return proposal.Proponents.Count(proponent => proponent.Age < 18) == 0;
    }

    //    A renda do proponente principal deve ser pelo menos:
    //      4 vezes o valor da parcela do empréstimo, se a idade dele for entre 18 e 24 anos
    //      3 vezes o valor da parcela do empréstimo, se a idade dele for entre 24 e 50 anos
    //      2 vezes o valor da parcela do empréstimo, se a idade dele for acima de 50 anos
    public static bool HasCompatibleIncome(Proponent proponent, decimal installmentValue)
    {
      if (proponent.Age < 18)
        return false;
//        throw new Exception("Proponent under 18");
      
      if (proponent.Age <= 24)
        return proponent.MonthlyIncome >= installmentValue * 4;
      if (proponent.Age <= 50)
        return proponent.MonthlyIncome >= installmentValue * 3;
      
      return proponent.MonthlyIncome >= installmentValue * 2;
    }
  }
}
