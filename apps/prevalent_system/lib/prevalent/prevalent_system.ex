defmodule Prevalent.System do
    use GenServer

    def start_link(state, opts \\ []) do
        GenServer.start_link(Prevalent.System, state, opts)
    end

    def handle_call({:execute, command}, _from, actual_state) do
        result = command.("")
        {:reply, {:executed, result}, actual_state}
    end
end