defmodule Prevalent.SystemTest do
  use ExUnit.Case, async: false
  doctest Prevalent.SystemApi
    @tag :PrevalentSystemTest
    test "take snapshot of the system" do
        assert {:executed} == Prevalent.SystemApi.reload_system
        assert {:executed} == Prevalent.SystemApi.execute {add_language(), "Erlang"}
        assert {:executed} == Prevalent.SystemApi.execute {add_language(), "Elixir"}
        assert {:executed} == Prevalent.SystemApi.take_snapshot
        assert {:executed} ==  Prevalent.SystemApi.reload_system
        assert {:executed} == Prevalent.SystemApi.execute {clear_languages(), []}
        assert {:executed} == Prevalent.SystemApi.reload_system
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
