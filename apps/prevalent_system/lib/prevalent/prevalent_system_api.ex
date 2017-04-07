defmodule Prevalent.SystemApi do
    @moduledoc ""

    def start_link(state, opts \\ []) do
        GenServer.start_link(Prevalent.System, state, opts)
    end

    def execute(command) do
        GenServer.call(:prevalent_system, {:execute, command})
    end

    def reload_system do
        GenServer.call(:prevalent_system, {:reload_system})
    end

    def take_snapshot do
        GenServer.call(:prevalent_system, {:take_snapshot})
    end
end
