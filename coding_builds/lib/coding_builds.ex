defmodule CodingBuilds do
  @doc """
  # coding builds
  # GET https://cmcmus.coding.net/api/enterprise/cmcmus/workbench/builds?page=1&pageSize=30
  """
  def main(_args \\ []) do
    token = Application.fetch_env!(:coding_builds, :token)

    url = "https://cmcmus.coding.net/api/enterprise/cmcmus/workbench/builds"

    # ====== Headers ======
    headers = [
      {"Authorization", "token #{token}"}
    ]

    # ====== Query Params ======
    params = [
      {"page", "1"},
      {"pageSize", "30"}
    ]

    HTTPoison.start()

    case HTTPoison.get(url, headers, params: params) do
      {:ok, %HTTPoison.Response{status_code: _status_code, body: body}} ->
        pretty_response(body)

      {:error, error = %HTTPoison.Error{reason: reason}} ->
        IO.puts("Request failed: #{reason}")

        error
    end
  end

  defp pretty_response(body) do
    result = Jason.decode!(body)

    case result["code"] do
      0 ->
        builds = result["data"]["list"]

        pretty_string =
          builds
          |> Enum.map(fn build -> "number #{build["number"]}" end)
          |> Enum.join("\n")

        IO.puts(pretty_string)

      _ ->
        IO.puts(body)
    end
  end
end
