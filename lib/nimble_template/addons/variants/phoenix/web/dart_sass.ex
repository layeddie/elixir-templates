defmodule NimbleTemplate.Addons.Phoenix.Web.DartSass do
  @moduledoc false

  use NimbleTemplate.Addons.Addon

  @dart_sass_version "1.49.8"

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> inject_mix_dependency()
    |> edit_config()
    |> edit_mix()
    |> edit_app_js()
  end

  defp inject_mix_dependency(%Project{} = project) do
    Generator.inject_mix_dependency(
      {:dart_sass, latest_package_version(:dart_sass), runtime: "Mix.env() == :dev"}
    )

    Generator.replace_content(
      "mix.exs",
      "runtime: \"Mix.env() == :dev\"",
      "runtime: Mix.env() == :dev"
    )

    project
  end

  defp edit_config(%Project{} = project) do
    Generator.replace_content(
      "config/config.exs",
      """
      # Configure esbuild (the version is required)
      """,
      """
      # Configure dart_sass (the version is required)
      config :dart_sass,
        version: "#{@dart_sass_version}",
        default: [
          args: ~w(css/app.scss ../priv/static/assets/app.css),
          cd: Path.expand("../assets", __DIR__)
        ]

      # Configure esbuild (the version is required)
      """
    )

    Generator.replace_content(
      "config/dev.exs",
      """
        watchers: [
      """,
      """
        watchers: [
          sass: {
            DartSass,
            :install_and_run,
            [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]
          },
      """
    )

    project
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            "assets.deploy": ["esbuild default --minify", "phx.digest"]
      """,
      """
            "assets.deploy": [
              "esbuild default --minify",
              "sass default --no-source-map --style=compressed",
              "phx.digest"
            ]
      """
    )

    project
  end

  defp edit_app_js(project) do
    Generator.delete_content(
      "assets/js/app.js",
      "import \"../css/app.css\""
    )

    project
  end
end
