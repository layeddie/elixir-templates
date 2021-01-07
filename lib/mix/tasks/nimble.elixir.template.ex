defmodule Mix.Tasks.Nimble.Elixir.Template do
  @shortdoc "Apply Nimble's Elixir/Phoenix template"

  @moduledoc """
  Apply Nimble's Elixir/Phoenix template

    mix nimble.elixir.template -v # Print the version
    mix nimble.elixir.template --web # Apply the Web template
    mix nimble.elixir.template --api # Apply the API template
    mix nimble.elixir.template --live # Apply the LiveView template
  """

  use Mix.Task

  alias Nimble.Elixir.Template.{Project, Template}

  @version Mix.Project.config()[:version]
  @variants [api: :boolean, web: :boolean, live: :boolean]

  def run([args]) when args in ~w(-v --version) do
    Mix.shell().info("Nimble.Elixir.Template v#{@version}")
  end

  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise("mix nimble.elixir.template can only be run inside an application directory")
    end

    {opts, _params} = parse_opts(args)

    {:ok, _} = Application.ensure_all_started(:httpoison)

    Template.apply(Project.new(opts))
  end

  defp parse_opts(args) do
    case OptionParser.parse(args, strict: @variants) do
      {opts, args, []} ->
        {opts, args}

      {_opts, _args, [switch | _]} ->
        Mix.raise("Invalid option: " <> humanize_variant_option(switch))
    end
  end

  defp humanize_variant_option({name, nil}), do: name
  defp humanize_variant_option({name, val}), do: name <> "=" <> val
end
