defmodule GEPABuildout.DomainTaskTest do
  use ExUnit.Case, async: true

  test "runs deterministic framework task and returns redacted projection" do
    assert {:ok, %GEPABuildout.DomainTask.Result{} = result} =
             GEPABuildout.DomainTask.run(%{
               task_ref: "task:buildout:answer-quality",
               dataset_ref: "dataset:buildout:examples",
               example_refs: ["example:buildout:1", "example:buildout:2"],
               trace_ref: "trace:buildout:domain-task"
             })

    assert result.framework_result.provider_dependency? == false

    assert result.projection == %{
             task_ref: "task:buildout:answer-quality",
             run_ref: "run:buildout:answer-quality",
             candidate_refs: ["candidate:component:buildout:instruction:v1"],
             best_candidate_ref: "candidate:component:buildout:instruction:v1",
             checkpoint: %{profile: :memory_ephemeral, restart_safe?: false},
             trace_refs: ["trace:buildout:domain-task"]
           }

    refute Map.has_key?(result.projection, :prompt)
    refute Map.has_key?(result.projection, :provider_payload)
    refute Map.has_key?(result.projection, :model_output)
    refute Map.has_key?(result.projection, :memory_body)
    refute Map.has_key?(result.projection, :secret)
  end
end
