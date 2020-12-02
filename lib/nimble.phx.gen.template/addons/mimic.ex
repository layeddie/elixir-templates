defmodule Nimble.Phx.Gen.Template.Addons.Mimic do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_test_helper()

    project
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency({:mimic, latest_package_version(:mimic), only: :test})

    project
  end

  defp edit_test_helper(project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      {:ok, _} = Application.ensure_all_started(:mimic)

      ExUnit.start()
      """
    )

    project
  end
end
