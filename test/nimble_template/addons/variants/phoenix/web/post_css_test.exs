defmodule NimbleTemplate.Addons.Phoenix.Web.PostCSSTest do
  use NimbleTemplate.AddonCase, async: false

  describe "#apply/2" do
    test "adds autoprefixer, postcss and postcss-loader into package.json", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.PostCSS.apply(project)

        assert_file("assets/package.json", fn file ->
          assert file =~ """
                   "devDependencies": {
                     "autoprefixer": "^10.4.1",
                     "postcss": "^8.4.5",
                     "postcss-loader": "^4.2.0",
                 """
        end)
      end)
    end

    test "adds postcss-loader to MiniCssExtractPlugin.loader", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.PostCSS.apply(project)

        assert_file("assets/webpack.config.js", fn file ->
          assert file =~ """
                             MiniCssExtractPlugin.loader,
                             'css-loader',
                             'postcss-loader',
                 """
        end)
      end)
    end

    test "copies the assets/postcss.config.js", %{
      project: project,
      test_project_path: test_project_path
    } do
      in_test_project(test_project_path, fn ->
        WebAddons.PostCSS.apply(project)

        assert_file("assets/postcss.config.js")
      end)
    end
  end
end
