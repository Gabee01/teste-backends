using System.IO;
using System.Linq;
using csharp;
using csharp.Proposal;
using FluentAssertions;
using Xunit;

namespace csharp_unit_tests
{
  public class RulesTests
  {
    [Theory]
    [InlineData("test/input/failing.txt", 1)]
    [InlineData("test/input/fixed.txt", 0)]
    public void ShouldDiscardDuplicates(string inputFileName, int duplicateEventsCount)
    {
      var inputLines = File.ReadAllLines(inputFileName);
      Solution.ProcessMessages(inputLines);

      Solution.DiscardedEvents.Count.Should().Be(duplicateEventsCount);
    }
    
    [Theory]
    [InlineData("test/input/failing.txt", 0)]
    [InlineData("test/input/fixed.txt", 1)]
    public void ShouldBeOverEighteen(string inputFileName, int minorProponentsCount)
    {
      var inputLines = File.ReadAllLines(inputFileName);
      Solution.ProcessMessages(inputLines);

      Solution.ReceivedProposals
        .Select(proposal => proposal.Proponents
          .Count(proponent => proponent.Age < 18))
        .Sum().Should().Be(minorProponentsCount);
    }
  }
}
