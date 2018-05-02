defmodule Issues.GithubIssues do

  @user_agent [ {"User-Agent", "Elixir dave@pragprog.com"} ]

  # the environment variable is fetched at compile time
  #@github_url "https://api.github.com"
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    # https://api.github.com/repos/elixir/elixir-lang/issues
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, Poison.Parser.parse!(body)}
  end

end
