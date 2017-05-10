defmodule Prevalent.SystemTest do
    use ExUnit.Case, async: false
    doctest Prevalent.SystemApi
    alias Prevalent.SystemApi, as: Api

    setup do
        on_exit fn ->
            Api.erase_data()
        end

        :ok
    end

    @tag :PrevalentSystemTest
    test "take snapshot of the system" do
        assert {:executed} == Api.execute {add_language(), "Erlang"}
        assert {:executed} == Api.execute {add_language(), "Elixir"}
        assert {:executed} == Api.take_snapshot
        assert {:executed} == Api.reload_system
        {:ok, value} = Api.query {query_languages(), %{}}
        assert Enum.empty?(value) == false
        assert Enum.count(value) == 2
        {:ok, result} = Api.query {query_language(), "Elixir"}
        assert Enum.at(result, 0) == "Elixir"
        assert {:executed} == Api.execute {clear_languages(), []}
        {:ok, value} = Api.query {query_languages(), %{}}
        assert Enum.empty?(value) == true
        assert Enum.count(value) == 0
        assert {:executed} == Api.reload_system
        assert {:executed} == Api.take_snapshot
    end

    defp add_language() do
        fn(actual_state, data) ->
            case actual_state[:languages] do
                nil -> Map.put(actual_state, :languages, [data])
                value when is_list(value) -> %{actual_state | languages: value ++ [data]}
            end
        end
    end

    defp clear_languages() do
        fn(actual_state, data) ->
            Map.put(actual_state, :languages, data)
        end
    end

    defp query_languages() do
        fn (actual_state, _criteria) ->
            case actual_state[:languages] do
                value when is_list(value) -> {:ok, value}
                _ -> {:error, "Attribute :languages not found."}
            end
        end
    end

    defp query_language() do
        fn (actual_state, criteria) ->
            case actual_state[:languages] do
                value when is_list(value) ->
                    result = Enum.filter(value, fn(each) -> each == criteria end)
                    {:ok, result}
                _ -> {:error, "Attribute :languages not found."}
            end
        end
    end
end
