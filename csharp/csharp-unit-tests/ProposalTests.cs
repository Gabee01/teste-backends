using System.IO;
using System.Linq;
using csharp;
using csharp.Proposal;
using FluentAssertions;
using Xunit;

namespace csharp_unit_tests
{
  public class ProposalTests
  {
    private Proposal _proposal { get; set; }
    private Proposal _validProposal { get; set; }

    public ProposalTests()
    {
      _proposal = new Proposal(new[]{"7eaa49ac-f52b-49e3-9e07-6501d0f28c30","462510.0","24"});
      _validProposal = new Proposal(new []{"7eaa49ac-f52b-49e3-9e07-6501d0f28c30","462510.0","24"});
    }

    [Theory]
    [InlineData("test/input/failing.txt","test/output/failing.txt")]
    [InlineData("test/input/fixed.txt","test/output/fixed.txt")]
    public void ShouldValidateProposals(string inputFileName, string outputFileName){
      var inputLines = File.ReadAllLines(inputFileName);
      var outputLines = File.ReadAllLines(outputFileName);
      var output = Solution.Solve(inputLines);
      output.Should().Be(outputLines[0]);
    }

    [Theory]
    [InlineData("test/input/failing.txt", 1)]
    [InlineData("test/input/fixed.txt", 0)]
    public void ShouldDiscardDuplicates(string inputFileName, int duplicateEventsCount)
    {
      var inputLines = File.ReadAllLines(inputFileName);
      Solution.ProcessMessages(inputLines);

      Solution.DiscardedEvents.Count.Should().Be(duplicateEventsCount);
    }


    [Fact]
    public void ShouldAddProponent()
    {
      var name = "Alexis Altenwerth I";
      var age = 44;
      var monthlyIncome = 21305.38;
      var isMain = "true";

      var proponentParams = new[]
      {
        "2019-11-11T13:26:04Z", "4ee3e203-5afb-43e5-a627-22973b2f566c", name, age.ToString(), monthlyIncome.ToString(),
        isMain
      };
      
      _proposal.AddProponent(proponentParams);
      _proposal.Proponents.Count.Should().Be(1);
      _proposal.Proponents.First().Age.Should().Be(age);
      _proposal.Proponents.First().Name.Should().Be(name);
      _proposal.Proponents.First().MonthlyIncome.Should().Be((decimal)monthlyIncome);
      _proposal.Proponents.First().IsMainProponent.Should().BeTrue();
    }
    
    [Fact]
    public void ShouldUpdateProponent()
    {
      var name = "Alexis Altenwerth I";
      var age = 44;
      var monthlyIncome = 21305.38;
      var isMain = "true";
      
      var proponentParams = new[]
      {
        "2019-11-11T13:26:04Z","4ee3e203-5afb-43e5-a627-22973b2f566c", name, age.ToString(), monthlyIncome.ToString(), isMain
      };
      
      _proposal.AddProponent(proponentParams);

      name = "Alexia I";
      age = 12;
      monthlyIncome = 12000.0;
      isMain = "false";
      
      proponentParams = new[]
      {
        "2019-11-11T13:26:04Z","4ee3e203-5afb-43e5-a627-22973b2f566c", name, age.ToString(), monthlyIncome.ToString(), isMain
      };
      
      _proposal.UpdateProponent(proponentParams);
      
      _proposal.Proponents.Count.Should().Be(1);
      _proposal.Proponents.First().Age.Should().Be(age);
      _proposal.Proponents.First().Name.Should().Be(name);
      _proposal.Proponents.First().MonthlyIncome.Should().Be((decimal)monthlyIncome);
      _proposal.Proponents.First().IsMainProponent.Should().BeFalse();
    }
    
    [Fact]
    public void ShouldRemoveProponent()
    {
      var name = "Alexis Altenwerth I";
      var age = 44;
      var monthlyIncome = 21305.38;
      var isMain = "true";
      
      var proponentParams = new[]
      {
        "2019-11-11T13:26:04Z", "4ee3e203-5afb-43e5-a627-22973b2f566c", name, age.ToString(), monthlyIncome.ToString(), isMain
      };
      
      _proposal.AddProponent(proponentParams);

      name = "Elexas Altenwerth I";
      age = 14;
      monthlyIncome = 400000.0;
      isMain = "false";
      
      proponentParams = new[]
      {
        "2019-11-11T13:26:04Z","aaa3e203-5afb-43e5-a627-22973b2f566c", name, age.ToString(), monthlyIncome.ToString(), isMain
      };
      
      _proposal.AddProponent(proponentParams);

      var removeProponentPayload = new[] {"2019-11-11T13:26:04Z","aaa3e203-5afb-43e5-a627-22973b2f566c"};
      
      _proposal.RemoveProponent(removeProponentPayload);

      _proposal.Proponents.Count.Should().Be(1);
      _proposal.Proponents.First().Id.Should().Be("4ee3e203-5afb-43e5-a627-22973b2f566c");

    }
    
    [Fact]
    public void ShouldAddWarranty()
    {
      var province = "BA";
      var value = 1728052.71;
      
      var warrantyParams = new[]
      {
        "2019-11-11T13:26:04Z","a86ec059-d928-44dd-86bb-faceac45f86f", value.ToString(),province
      };
      
      _proposal.AddWarranty(warrantyParams);
      _proposal.Warranties.Count.Should().Be(1);
      _proposal.Warranties.First().Province.Should().Be(province);
      _proposal.Warranties.First().Value.Should().Be((decimal)value);
    }
    
    [Fact]
    public void ShouldUpdateWarranty()
    {
      var province = "BA";
      var value = 1728052.71;
      
      var warrantyParams = new[]
      {
        "2019-11-11T13:26:04Z","a86ec059-d928-44dd-86bb-faceac45f86f", value.ToString(),province
      };
      
      _proposal.AddWarranty(warrantyParams);

      province = "PR";
      value = 6668052.71;
      
      warrantyParams = new[]
      {
        "2019-11-11T13:26:04Z","a86ec059-d928-44dd-86bb-faceac45f86f", value.ToString(),province
      };
      
      _proposal.UpdateWarranty(warrantyParams);
      
      _proposal.Warranties.Count.Should().Be(1);
      _proposal.Warranties.First().Province.Should().Be(province);
      _proposal.Warranties.First().Value.Should().Be((decimal)value);
    }
    
    [Fact]
    public void ShouldRemoveWarranty()
    {
      var warrantyParams = new[]
      {
        "2019-11-11T13:26:04Z","a86ec059-d928-44dd-86bb-faceac45f86f","1728052.71","BA"
      };
      
      _proposal.AddWarranty(warrantyParams);
      
      warrantyParams = new[]
      {
        "2019-11-11T13:26:04Z","aaaec059-d928-44dd-86bb-faceac45f86f","100028052.71","BB"
      };
      
      _proposal.AddWarranty(warrantyParams);
      
      var removeProponentPayload = new[] {"2019-11-11T13:26:04Z","aaaec059-d928-44dd-86bb-faceac45f86f"};
      
      _proposal.RemoveWarranty(removeProponentPayload);
      _proposal.Warranties.Count.Should().Be(1);
      _proposal.Warranties.First().Id.Should().Be("a86ec059-d928-44dd-86bb-faceac45f86f");
    }
  }
}
