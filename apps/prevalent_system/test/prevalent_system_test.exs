defmodule Prevalent.SystemTest do
  use ExUnit.Case, async: false
  doctest Prevalent.SystemApi
    @tag :PrevalentSystemTest
    test "take snapshot of the system" do
        {:executed, value} = Prevalent.SystemApi.execute {fn(actual_state, data) -> data end, "teste"}
        assert value == %{}
        {:executed, value} = Prevalent.SystemApi.reload_system
        assert value == %{}
        assert {:executed} == Prevalent.SystemApi.take_snapshot
    end
end
