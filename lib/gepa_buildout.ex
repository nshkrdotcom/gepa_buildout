defmodule GEPABuildout do
  @moduledoc """
  Public facade for deterministic GEPA domain task examples.
  """

  defdelegate run_domain_task(input), to: GEPABuildout.DomainTask, as: :run
end
