defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        {:ok, str_time} = Timex.format(Timex.now, "{ISO:Extended}")
        {:ok, dir} = File.cwd()
        File.mkdir_p("commands")
        File.cd("commands")
        {:ok, file} = File.open "command_"<>str_time<>".dat", [:write]
        IO.binwrite file, :erlang.term_to_binary(command)
        File.close file
        File.cd(dir)
        {function, data} = command
        result = function.(actual_state, data)
        {:reply, {:executed, actual_state}, actual_state}
    end

    def handle_call({:reload_system}, _from, actual_state) do
        {:ok, dir} = File.cwd()
        File.cd("commands")
        {:ok, list_of_commands} = File.ls(".")
        IO.inspect(list_of_commands)

        #load file with system that contains actual_state

        result = List.foldr(list_of_commands, actual_state, fn(path, acc) ->
            {:ok, binary} = File.read(path)
            command = :erlang.binary_to_term(binary)
            {function, data} = command
            function.(actual_state, data)
            actual_state
        end)

        File.cd(dir)
        IO.inspect(result)
        {:reply, {:executed, result}, result}
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        {:ok, dir} = File.cwd()
        File.mkdir_p("snapshot")
        File.cd("snapshot")
        {:ok, file} = File.open "prevalent_system.dat", [:write]
        IO.binwrite file, :erlang.term_to_binary(actual_state)
        File.close file
        File.cd(dir)

        File.cd("commands")
        {:ok, list_of_commands} = File.ls(".")
        Enum.each(list_of_commands, fn(path) -> File.rm(path) end)
        File.cd(dir)
        {:reply, {:executed}, actual_state}
    end
end