defmodule Nimble.Phx.Gen.Template.Addons.Mox do
  use Nimble.Phx.Gen.Template.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> copy_files()
    |> edit_files()
  end

  defp copy_files(%Project{base_module: base_module} = project) do
    Generator.copy_file([{:eex, "test/support/mock.ex.eex", "test/support/mock.ex"}],
      base_module: base_module
    )

    project
  end

  defp edit_files(%Project{} = project) do
    project
    |> inject_mix_dependency()
    |> edit_test_helper()

    project
  end

  defp inject_mix_dependency(project) do
    Generator.inject_mix_dependency({:mox, package_version(:mox), only: :test})

    project
  end

  defp edit_test_helper(project) do
    Generator.replace_content(
      "test/test_helper.exs",
      """
      ExUnit.start()
      """,
      """
      {:ok, _} = Application.ensure_all_started(:mox)

      ExUnit.start()
      """
    )

    project
  end
end
