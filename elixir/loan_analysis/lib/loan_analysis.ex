defmodule LoanAnalysis do
  alias LoanAnalysis.Event.EventWorker
  defdelegate test_solution(), to: EventWorker, as: :test_all_files
end
