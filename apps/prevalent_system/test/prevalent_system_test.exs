defmodule Prevalent.SystemTest do
  use ExUnit.Case, async: true
  doctest Prevalent.SystemApi

    @tag :PrevalentSystemTest
    test "execute command on system" do
        {:executed, value} = Prevalent.SystemApi.execute(
            fn(teste) -> "teste" end
        )
        assert value == "teste"
    end
end
