defmodule Prevalent.System do
    use GenServer

    def start_link(state, opts \\ []) do
        GenServer.start_link(Prevalent.System, state, opts)
    end

    def handle_call({:execute, _command}, _from, actual_state) do
        {:reply, {:executed}, actual_state}
    end
end