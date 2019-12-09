using System.Collections.Generic;
using System.Linq;

namespace csharp.Event
{
  public static class EventSpecification
  {
    public static bool isProposalCreated(Event @event){
      return @event.schema == "proposal" && @event.action == "created";
    }
    public static bool isProposalUpdated(Event @event){
      return @event.schema == "proposal" && @event.action == "updated";
    }
    public static bool isProposalDeleted(Event @event){
      return @event.schema == "proposal" && @event.action == "deleted";
    }
    public static bool isWarrantyAdded(Event @event){
      return @event.schema == "warranty" && @event.action == "added";
    }
    public static bool isWarrantyUpdated(Event @event){
      return @event.schema == "warranty" && @event.action == "updated";
    }
    public static bool isWarrantyRemoved(Event @event){
      return @event.schema == "warranty" && @event.action == "removed";
    }
    public static bool isProponentAdded(Event @event){
      return @event.schema == "proponent" && @event.action == "added";
    }
    public static bool isProponentUpdated(Event @event){
      return @event.schema == "proponent" && @event.action == "updated";
    }
    public static bool isProponentRemoved(Event @event){
      return @event.schema == "proponent" && @event.action == "removed";
    }

    //  Em caso de eventos atrasados, considere sempre o evento mais novo
    //      Por exemplo, ao receber dois eventos de atualização com IDs diferentes, porém o último evento tem um timestamp mais antigo do que o primeiro, descarte o evento mais antigo
    public static bool isOld(List<Event> processedEvents, Event currentEvent)
    {
      return processedEvents.Any(processedEvent =>
        processedEvent.action == currentEvent.action && processedEvent.schema == currentEvent.schema &&
        processedEvent.timestamp > currentEvent.timestamp);

    }
  }
}
