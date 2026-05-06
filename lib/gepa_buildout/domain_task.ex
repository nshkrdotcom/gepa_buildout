defmodule GEPABuildout.DomainTask.Result do
  @moduledoc """
  Redacted buildout result projected from a framework run.
  """

  @type t :: %__MODULE__{
          framework_result: GEPAFramework.GEPA.Result.t(),
          projection: map()
        }

  @enforce_keys [:framework_result, :projection]
  defstruct [:framework_result, :projection]
end

defmodule GEPABuildout.DomainTask do
  @moduledoc """
  Deterministic answer-quality task over `GEPAFramework`.
  """

  alias GEPABuildout.DomainTask.Result
  alias GEPAFramework.Runtime
  alias GEPAFramework.Value

  @spec run(map() | keyword()) :: {:ok, Result.t()} | {:error, term()}
  def run(input) do
    framework_input = framework_config(input)

    with {:ok, framework_result} <-
           Runtime.run(framework_input,
             examples: Value.string_list(Value.get(input, :example_refs, []))
           ) do
      {:ok,
       %Result{
         framework_result: framework_result,
         projection: projection(input, framework_result)
       }}
    end
  end

  defp framework_config(input) do
    task_ref = Value.get(input, :task_ref, "task:buildout:answer-quality")
    dataset_ref = Value.get(input, :dataset_ref, "dataset:buildout:examples")
    trace_ref = Value.get(input, :trace_ref, "trace:buildout:domain-task")

    [
      runtime_ref: "run:buildout:answer-quality",
      task: %{
        task_ref: task_ref,
        dataset_ref: dataset_ref
      },
      components: [
        %{
          component_ref: "component:buildout:instruction:v1",
          kind: :instruction,
          content_ref: "artifact:buildout:instruction:v1"
        }
      ],
      adapters: [
        %{
          adapter_ref: "adapter:buildout:mock-llm",
          type: :llm,
          mode: :deterministic_mock
        }
      ],
      data_loader: %{
        loader_ref: "loader:buildout:inline",
        example_refs: Value.string_list(Value.get(input, :example_refs, []))
      },
      evaluator: %{
        evaluator_ref: "eval:buildout:exact",
        objective_refs: ["objective:buildout:exact"]
      },
      proposer: %{
        proposer_ref: "proposer:buildout:deterministic",
        strategy: :deterministic_reflection
      },
      merge: %{
        merge_ref: "merge:disabled",
        strategy: :disabled
      },
      tracing: %{
        trace_refs: [trace_ref]
      },
      persistence: %{
        profile: :memory_ephemeral
      }
    ]
  end

  defp projection(input, framework_result) do
    %{
      task_ref: Value.get(input, :task_ref, "task:buildout:answer-quality"),
      run_ref: framework_result.run_ref,
      candidate_refs: framework_result.candidate_refs,
      best_candidate_ref: framework_result.best_candidate_ref,
      checkpoint: GEPAFramework.Persistence.to_projection(framework_result.checkpoint),
      trace_refs: framework_result.trace_refs
    }
  end
end
