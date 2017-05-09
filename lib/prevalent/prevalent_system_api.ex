defmodule Prevalent.SystemApi do
    @moduledoc ""

    def start_link(state, opts \\ []) do
        result = GenServer.start_link(Prevalent.System, state, opts)
        reload_system()
        result
    end

    def execute(command) do
        GenServer.call(:prevalent_system, {:execute, command})
    end

    def query(command) do
        GenServer.call(:prevalent_system, {:query, command})
    end

    def reload_system do
        GenServer.call(:prevalent_system, {:reload_system})
    end

    def take_snapshot do
        GenServer.call(:prevalent_system, {:take_snapshot})
    end

    def erase_data do
        GenServer.call(:prevalent_system, {:erase_data})
    end
end
