Code.require_file("build_support/workspace_contract.exs", __DIR__)
Code.require_file("build_support/dependency_resolver.exs", __DIR__)

defmodule GEPABuildout.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/nshkrdotcom/gepa_buildout"

  def project do
    [
      app: :gepa_buildout,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      dialyzer: [plt_add_deps: :apps_tree],
      name: "GEPA Buildout",
      description: "Deterministic GEPA domain task buildout",
      source_url: @source_url,
      homepage_url: @source_url,
      package_paths: GEPABuildout.Build.WorkspaceContract.package_paths()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def cli do
    [
      preferred_envs: [
        ci: :test,
        credo: :test,
        dialyzer: :test,
        docs: :dev
      ]
    ]
  end

  defp deps do
    [
      {:gepa_framework, GEPABuildout.Build.DependencyResolver.gepa_framework()},
      {:weld, "~> 0.7.2", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      ci: [
        "deps.get",
        "format --check-formatted",
        "compile --warnings-as-errors",
        "test",
        "credo --strict",
        "dialyzer --format short",
        "docs",
        "weld.verify"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "main",
      source_url: @source_url,
      homepage_url: @source_url
    ]
  end
end
