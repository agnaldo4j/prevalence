defmodule Prevalent.SystemApi do

    def start_link(state, opts \\ []) do
        GenServer.start_link(Prevalent.System, state, opts)
    end

    def execute(command) do
        GenServer.call(:prevalent_system, {:execute, command})
    end
end