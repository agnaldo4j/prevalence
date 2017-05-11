defmodule Prevalent.JournalingTest do
    use ExUnit.Case, async: false
    doctest Prevalent.Journaling
    alias Prevalent.Journaling, as: Api

    setup do
        on_exit fn ->
            Api.erase_data()
        end

        :ok
    end

    @tag :PrevalentJournalingTest
    test "the journaling log command" do
        command = Api.log_command(add_language())
        assert command == add_language()
    end

    @tag :PrevalentJournalingTest
    test "the journaling load commands" do
        Api.log_command( {add_language(), "Elixir"})
        Api.log_command( {add_language(), "Erlang"})
        Api.log_command( {add_language(), "Elm"})
        {_snapshot, list_of_commands} = Api.load_system_state()
        assert Enum.count(list_of_commands) == 3
        resultPath = Enum.at(list_of_commands, 0)<>Enum.at(list_of_commands, 1)<>Enum.at(list_of_commands, 2)
        reduceResultPath = Enum.reduce(list_of_commands, "", fn(path, acc) -> acc <> path end)
        assert resultPath == reduceResultPath
    end

    @tag :PrevalentJournalingTest
    test "the journaling take snapshot" do
        actual_state = %{languages: ["Elixir", "Erlang", "Elm"]}
        Api.take_snapshot(actual_state)

        {snapshot, list_of_commands} = Api.load_system_state()
        assert Enum.count(list_of_commands) == 0
        assert Enum.count(snapshot.languages) == 3
        reduceLanguages = Enum.reduce(snapshot.languages, "", fn(language, acc) -> acc <> language end)
        assert "ElixirErlangElm" == reduceLanguages
    end



    defp add_language do
        fn(actual_state, data) ->
            case actual_state[:languages] do
                nil -> Map.put(actual_state, :languages, [data])
                value when is_list(value) -> %{actual_state | languages: value ++ [data]}
            end
        end
    end
end
