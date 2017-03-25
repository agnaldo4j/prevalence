defmodule Prevalent.System do
    use GenServer

    def handle_call({:execute, command}, _from, actual_state) do
        :erlang.term_to_binary(command)
        {function, data} = command
        result = function.(actual_state, data)
        {:reply, {:executed, result}, actual_state}
    end
end