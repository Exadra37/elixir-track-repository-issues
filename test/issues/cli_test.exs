defmodule Issues.CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
  ]

  # TODO: No need to test a function that should be private?
  test ":help returned by option parsing with -h and --help options"  do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  # TODO: No need to test a function that should be private?
  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  # TODO: No need to test a function that should be private?
  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort ascending orders the correct way" do
    # TODO: Why we use a fake list that doesn't tests the sort order with real
    #       examples, that represent a date?
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{a b c}
  end

  def fake_created_at_list(values) do
    for value <- values do
      %{"created_at" => value, "other_data" => "xxx"}
    end
  end
end
