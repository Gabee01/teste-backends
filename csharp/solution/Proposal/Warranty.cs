namespace csharp.Proposal
{
  public class Warranty
  {
    public Warranty(string[] eventPayload)
    {
      Id = eventPayload[1];
      Value = decimal.Parse(eventPayload[2]);
      Province = eventPayload[3];
    }
    
    public string Id { get; set; }
    public decimal Value { get; set; }
    public string Province { get; set; }
  }
}
