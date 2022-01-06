defmodule NimbleTemplate.Addons.Phoenix.Web.NimbleCSSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "copies Nimble JS structure", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleCSS.apply(project)

        assert_directory("assets/css/base")
        assert_directory("assets/css/components")
        assert_directory("assets/css/functions")
        assert_directory("assets/css/layouts")
        assert_directory("assets/css/mixins")
        assert_directory("assets/css/screens")
        assert_directory("assets/css/vendor")

        assert_file("assets/css/_variables.scss")
        assert_file("assets/css/app.scss")
      end)
    end

    test "removes the default Phoenix styles", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleCSS.apply(project)

        refute_file("assets/css/app.css")
        refute_file("assets/css/phoenix.css")
      end)
    end

    test "imports `css/app.scss` into assets/js/app.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleCSS.apply(project)

        assert_file("assets/js/app.js", fn file ->
          assert file =~ "css/app.scss"
          refute file =~ "css/app.css"
        end)
      end)
    end

    test "removes `css/app.css` and `css/phoenix.css` in assets/.stylelintrc.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        AddonsWeb.NimbleCSS.apply(project)

        assert_file("assets/.stylelintrc.json", fn file ->
          refute file =~ "css/app.css"
          refute file =~ "css/phoenix.css"
        end)
      end)
    end
  end
end
