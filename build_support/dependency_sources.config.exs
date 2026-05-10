%{
  deps: %{
    gepa_framework: %{
      path: "../gepa_framework",
      github: %{repo: "nshkrdotcom/gepa_framework", branch: "main"},
      hex: "~> 0.1.0",
      default_order: [:path, :github, :hex],
      publish_order: [:hex]
    }
  }
}
