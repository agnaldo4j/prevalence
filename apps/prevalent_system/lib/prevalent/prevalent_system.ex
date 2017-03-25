defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        {:ok, str_time} = Timex.format(Timex.now, "{ISO:Extended}")
        {:ok, file} = File.open "command_"<>str_time<>".dat", [:write]
        IO.binwrite file, :erlang.term_to_binary(command)
        File.close file
        {function, data} = command
        result = function.(actual_state, data)
        {:reply, {:executed, result}, actual_state}
    end
end