defmodule Nimble.Phx.Gen.Template.Addons.ExCoveralls do
  use Nimble.Phx.Gen.Template.Addon

  @versions %{
    excoveralls: "~> 0.12.2"
  }

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{otp_app: otp_app} = project) do
    # There is no test for `lib/*/router.ex` on the new Phoenix app, so that reduce the coverage to 77.8%
    # We are setting the minimum_coverage as 77 to work with the new Phoenix app
    binding = [
      otp_app: project.otp_app,
      minimum_coverage: 77
    ]

    Generator.copy_file([{:eex, "coveralls.json.eex", "coveralls.json"}], binding)

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_mix()
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency({:excoveralls, @versions.excoveralls, only: :test})

    project
  end

  defp edit_mix(project) do
    Generator.replace_content(
      "mix.exs",
      """
            deps: deps()
      """,
      """
            deps: deps(),
            test_coverage: [tool: ExCoveralls],
            preferred_cli_env: [
              lint: :test,
              coverage: :test,
              coveralls: :test,
              "coveralls.html": :test
            ]
      """
    )

    Generator.inject_content(
      "mix.exs",
      """
        defp aliases do
          [
      """,
      """
            coverage: ["coveralls.html --raise"],
      """
    )

    project
  end
end
