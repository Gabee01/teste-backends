using System;
using System.IO;

namespace csharp
{
  static class Program
    {
        static void Main()
        {
          Console.WriteLine("Starting tests...");

          string[] inputFiles = {
            "./../test/input/input000.txt",
            "./../test/input/input001.txt",
            "./../test/input/input002.txt",
            "./../test/input/input003.txt",
            "./../test/input/input004.txt",
            "./../test/input/input005.txt",
            "./../test/input/input006.txt",
            "./../test/input/input007.txt",
            "./../test/input/input008.txt",
            "./../test/input/input009.txt",
            "./../test/input/input010.txt",
            "./../test/input/input011.txt",
            "./../test/input/input012.txt"
          };

          string[] outputFiles = {
            "./../test/output/output000.txt",
            "./../test/output/output001.txt",
            "./../test/output/output002.txt",
            "./../test/output/output003.txt",
            "./../test/output/output004.txt",
            "./../test/output/output005.txt",
            "./../test/output/output006.txt",
            "./../test/output/output007.txt",
            "./../test/output/output008.txt",
            "./../test/output/output009.txt",
            "./../test/output/output010.txt",
            "./../test/output/output011.txt",
            "./../test/output/output012.txt"
          };

          for(var i = 0; i <= outputFiles.Length - 1; ++i) {
            var inputPath = inputFiles[i];
            var outputPath = outputFiles[i];

            var inputLines = File.ReadAllLines(inputPath);
            var outputLines = File.ReadAllLines(outputPath);

            var output = Solution.Solve(inputLines);
            
            Console.WriteLine(output.Equals(outputLines[0])
              ? $"Test {i + 1}/{outputFiles.Length} - Passed"
              : $"Test {i + 1}/{outputFiles.Length} - Failed\n expected: {outputLines[0]}\n result: {output}");
          }
        }
    }
}
