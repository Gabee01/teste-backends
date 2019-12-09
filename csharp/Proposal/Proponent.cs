

namespace csharp.Proposal
{
  public class Proponent
  {
    public Proponent(string[] eventPayload)
    {
      Id = eventPayload[1];
      Name = eventPayload[2];
      Age = int.Parse(eventPayload[3]);
      MonthlyIncome = decimal.Parse(eventPayload[4]);
      IsMainProponent = bool.Parse(eventPayload[5]);
    }
    
    public string Id { get; set; }
    public string Name { get; set; }
    public bool IsMainProponent { get; set; }
    public int Age { get; set; }
    public decimal MonthlyIncome { get; set; }
  }
}
