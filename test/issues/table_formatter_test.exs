defmodule Issues.TableFormatterTest do

  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def simple_test_data() do
    [
      [
        "#": "7070",
        created_at: "2017-11-28T19:38:43Z",
        dummy: "dummy content for column not being used",
        title: "Inconsistency between DateTime and NaiveDateTime creation",
      ],
      [
        "#": "7095",
        created_at: "2017-12-08T08:43:04Z",
        dummy: "dummy content for column not being used",
        title: "Allow compile time purging to happen per application/module",
      ],
      [
        "#": "7097",
        created_at: "2017-12-08T19:52:38Z",
        dummy: "dummy content for column not being used",
        title: "Introduce __STACKTRACE__",
      ],
      [
        "#": "7198",
        created_at: "2018-01-11T13:34:07Z",
        dummy: "dummy content for column not being used",
        title: "Adopt EEP 48",
      ],
    ]
  end

  def headers() do
    [ :"#", :created_at, :title ]
  end

  def split_with_three_columns() do
    simple_test_data()
    |> TF.split_into_columns(headers())
  end

  test "split_into_columns" do

    columns = split_with_three_columns()

    assert length(columns) == length(headers())

    assert List.first(columns) == [
      "7070",
      "7095",
      "7097",
      "7198"
    ]

    assert List.last(columns) == [
      "Inconsistency between DateTime and NaiveDateTime creation",
      "Allow compile time purging to happen per application/module",
      "Introduce __STACKTRACE__",
      "Adopt EEP 48",
    ]

  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "Output is correct" do
    table_output = fn ->
      TF.print_table_for_columns(simple_test_data(), headers())
    end

    result = capture_io(table_output)

    assert result == """
    #    | created_at           | title                                                      
    -----+----------------------+------------------------------------------------------------
    7070 | 2017-11-28T19:38:43Z | Inconsistency between DateTime and NaiveDateTime creation  
    7095 | 2017-12-08T08:43:04Z | Allow compile time purging to happen per application/module
    7097 | 2017-12-08T19:52:38Z | Introduce __STACKTRACE__                                   
    7198 | 2018-01-11T13:34:07Z | Adopt EEP 48                                               
    """

  end

end
