defmodule GEPABuildout.Build.DependencyResolver do
  @moduledoc false

  @repo_root Path.expand("..", __DIR__)
  @gepa_framework_path Path.expand("../gepa_framework", @repo_root)

  def gepa_framework do
    if File.dir?(@gepa_framework_path) do
      [path: @gepa_framework_path]
    else
      [git: "https://github.com/nshkrdotcom/gepa_framework.git", branch: "main"]
    end
  end
end
