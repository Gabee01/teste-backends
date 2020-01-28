defmodule LoanAnalysis.Helper do
  alias LoanAnalysis.{Proposals}

  def start() do
    Proposals.start_link()
  end

  def read_file(file) do
    File.read!(file)
      |> String.split("\n")
  end
end
