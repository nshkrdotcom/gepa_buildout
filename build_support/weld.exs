Code.require_file("workspace_contract.exs", __DIR__)

defmodule GEPABuildout.Build.WeldContract do
  @moduledoc false

  @repo_root Path.expand("..", __DIR__)
  @gepa_framework_repo_path Path.expand("../gepa_framework", @repo_root)

  @dependencies [
    gepa_framework: [
      opts:
        if File.dir?(@gepa_framework_repo_path) do
          [git: @gepa_framework_repo_path]
        else
          [github: "nshkrdotcom/gepa_framework", branch: "main"]
        end
    ]
  ]

  def manifest do
    [
      workspace: [
        root: "..",
        project_globs: GEPABuildout.Build.WorkspaceContract.active_project_globs()
      ],
      classify: [
        tooling: ["."]
      ],
      publication: [
        internal_only: ["."]
      ],
      dependencies: @dependencies,
      artifacts: [
        gepa_buildout: artifact()
      ]
    ]
  end

  def artifact do
    [
      roots: ["."],
      package: [
        name: "gepa_buildout",
        otp_app: :gepa_buildout,
        version: "0.1.0",
        description: "Deterministic GEPA domain task buildout"
      ],
      output: [
        docs: ["README.md"],
        assets: ["assets/gepa_buildout.svg"]
      ],
      verify: [
        artifact_tests: ["test"],
        hex_build: false,
        hex_publish: false
      ]
    ]
  end
end

GEPABuildout.Build.WeldContract.manifest()
