defmodule Nimble.Elixir.Template.Hex.HexClient do
  alias Nimble.Elixir.Template.HttpClient.HttpAdapter

  @base_url "https://hex.pm/api/"

  def get(path) do
    url = @base_url <> URI.encode(path)

    case HttpAdapter.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
