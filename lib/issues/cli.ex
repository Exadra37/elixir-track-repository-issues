defmodule Issues.CLI do

  @default_count 4

  alias Issues.TableFormatter

  @moduledoc """
  Handle the command line parsing and the dispatch to the various
  functions that end up generating a table of the last _n_ issues
  in a github project.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `arv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if help was
  given.
  """

  # TODO: having this function public just to be able to test it?
  def parse_args(argv) do

    options =  [
      switches: [help: :bolean],
      aliases:  [h:    :help]
    ]

    parse = OptionParser.parse(argv, options)

    case parse do
      {[help: true], _, _}
        -> :help

      {_, [user, project, count], _}
        -> {user, project, String.to_integer(count)}

      {_, [user, project], _}
        -> {user, project, @default_count}

      _ -> :help

    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> TableFormatter.print_table_for_columns(["number", "created_at", "title"])
  end

  # TODO:
  #   → CLI only responsibility should be to get the user input.
  #   → The function name is not appropriated for what it does, once
  #     the response comes already decoded from Github Issues module.
  #   → A better name would be filter_response and should be moved
  #     to a dedicated module.
  #   → As it is now is violating the Single Responsibility Principle.

  # TODO: Why is this a public function?
  def decode_response({:ok, body}) do
    body
  end

  # TODO: Why is this a public function?
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  # TODO: Why is this a public function?
  def sort_into_ascending_order(list_of_issues) do
    function =
      fn issue1, issue2 ->
        Map.get(issue1, "created_at") <= Map.get(issue2, "created_at")
      end
    Enum.sort(list_of_issues, function)
  end

  def format_table(issues) do
    IO.inspect issues
  end

end
