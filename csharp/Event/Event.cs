using System;
using System.Linq;

namespace csharp.Event
{ 
  public class Event
  {
    public Event(string[] inputText)
    {
      id = inputText[0];
      schema = inputText[1];
      action = inputText[2];
      timestamp = DateTime.Parse(inputText[3]);
      payload = inputText.Skip(4).ToArray();
    }
    
    public string id;
    public string schema;
    public string action;
    public DateTime timestamp;
    public string[] payload;
  }
}
