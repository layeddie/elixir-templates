defmodule Nimble.Phx.Gen.Template.Mix.Template do
  alias Nimble.Phx.Gen.Template.{Addons, Project}

  def apply(%Project{} = project) do
    project
    |> Addons.ElixirVersion.apply()
    |> Addons.TestEnv.apply()
    |> Addons.Credo.apply()
    |> Addons.Dialyxir.apply()

    project
  end
end
