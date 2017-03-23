defmodule Prevalent.SystemApi do
    def execute(command) do
        GenServer.call(:prevalent_system, {:execute, command})
    end
end