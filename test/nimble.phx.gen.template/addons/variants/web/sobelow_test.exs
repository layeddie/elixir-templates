defmodule Nimble.Phx.Gen.Template.Addons.Web.SobelowTest do
  use Nimble.Phx.Gen.Template.AddonCase

  import Mox

  setup %{project: project, test_project_path: test_project_path} do
    mock_latest_package_version(:credo, "0.26.2")
    mock_latest_package_version(:sobelow, "0.8")

    {:ok, project: project, test_project_path: test_project_path}
  end

  describe "#apply/2" do
    @describetag required_addons: [:TestEnv, :Credo]

    test "copies the .sobelow-conf", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Web.Sobelow.apply(project)

        assert_file(".sobelow-conf")
      end)
    end

    test "injects sobelow to mix dependency", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        Addons.Web.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp deps do
                     [
                       {:sobelow, \"~> 0.8\", [only: [:dev, :test], runtime: false]},
                 """
        end)
      end)
    end

    test "adds sobelow codebase alias", %{project: project, test_project_path: test_project_path} do
      in_test_project(test_project_path, fn ->
        Addons.Web.Sobelow.apply(project)

        assert_file("mix.exs", fn file ->
          assert file =~ """
                   defp aliases do
                     [
                       codebase: [\"format --check-formatted\", \"credo\", \"sobelow --config\"],
                 """
        end)
      end)
    end
  end
end
