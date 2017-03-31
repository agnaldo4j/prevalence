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

    def handle_call({:reload_system}, _from, actual_state) do
        {:reply, {:executed}, actual_state}
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        {:ok, file} = File.open "prevalent_system.dat", [:write]
        IO.binwrite file, :erlang.term_to_binary(actual_state)
        File.close file
        #delete actual commands from file system
        {:reply, {:executed}, actual_state}
    end
end