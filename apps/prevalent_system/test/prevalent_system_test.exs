defmodule Prevalent.SystemTest do
  use ExUnit.Case, async: false
  doctest Prevalent.SystemApi
    @tag :PrevalentSystemTest
    test "take snapshot of the system" do
        {:executed, value} = Prevalent.SystemApi.reload_system
        {:executed, value} = Prevalent.SystemApi.execute {add_language(), "Erlang"}
        assert value.languages == ["Erlang"]
        {:executed, value} = Prevalent.SystemApi.execute {add_language(), "Elixir"}
        assert value.languages == ["Erlang", "Elixir"]
        assert {:executed} == Prevalent.SystemApi.take_snapshot
        {:executed, value} = Prevalent.SystemApi.reload_system
        assert value.languages == ["Erlang", "Elixir"]
        {:executed, value} = Prevalent.SystemApi.execute {clear_languages(), []}
        assert value.languages == []
        {:executed, value} = Prevalent.SystemApi.reload_system
        assert value.languages == []
        assert {:executed} == Prevalent.SystemApi.take_snapshot
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
end
