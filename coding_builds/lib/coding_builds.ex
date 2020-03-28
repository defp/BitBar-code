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
      {"Authorization", "token #{token}"},
    ]

    # ====== Query Params ======
    params = [ 
      {"page", "1"},
      {"pageSize", "30"},
    ]

    HTTPoison.start()
    case HTTPoison.get(url, headers, params: params) do
      {:ok, response = %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("Response Status Code: #{status_code}")
        IO.puts("Response Body: #{body}")

        response
      {:error, error = %HTTPoison.Error{reason: reason}} ->
        IO.puts("Request failed: #{reason}")

        error
    end
  end
end
