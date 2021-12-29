defmodule NimbleTemplate.Addons.Phoenix.Web.StyleLint do
  @moduledoc false

  use NimbleTemplate.Addon

  @impl true
  def do_apply(%Project{} = project, _opts) do
    project
    |> edit_files()
    |> copy_files()
  end

  defp edit_files(%Project{} = project) do
    project
    |> edit_assets_package()
    |> edit_mix()

    project
  end

  defp copy_files(%Project{} = project) do
    Generator.copy_file([{:text, "assets/.stylelintrc.json", "assets/.stylelintrc.json"}])

    project
  end

  defp edit_assets_package(%Project{} = project) do
    Generator.replace_content(
      "assets/package.json",
      """
        "scripts": {
      """,
      """
        "scripts": {
          "stylelint": "stylelint --color ./css",
          "stylelint.fix": "stylelint --color --fix ./css",
      """
    )

    Generator.replace_content(
      "assets/package.json",
      """
        "devDependencies": {
      """,
      """
        "devDependencies": {
          "stylelint": "^13.13.1",
          "stylelint-config-property-sort-order-smacss": "^7.1.0",
          "stylelint-config-sass-guidelines": "^8.0.0",
      """
    )

    project
  end

  defp edit_mix(%Project{} = project) do
    Generator.replace_content(
      "mix.exs",
      """
            codebase: [
      """,
      """
            codebase: ["cmd npm run stylelint --prefix assets",
      """
    )

    Generator.replace_content(
      "mix.exs",
      """
            "codebase.fix": [
      """,
      """
            "codebase.fix": ["cmd npm run stylelint.fix --prefix assets",
      """
    )

    project
  end
end
