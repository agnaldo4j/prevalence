defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        Prevalent.Journaling.log_command(command)
        {function, data} = command
        result = function.(actual_state, data)
        {:reply, {:executed, result}, result}
    end

    def handle_call({:reload_system}, _from, actual_state) do
        {:ok, dir} = File.cwd()
        saved_state = Prevalent.Journaling.load_snapshot()
        File.cd(dir)
        list_of_commands = Prevalent.Journaling.load_list_of_commands()
        File.cd(dir)

        result = List.foldr(list_of_commands, saved_state, fn(path, acc) ->
            {:ok, binary} = Prevalent.Journaling.load_command(path)
            command = :erlang.binary_to_term(binary)
            {function, data} = command
            function.(saved_state, data)
        end)
        File.cd(dir)

        {:reply, {:executed, result}, result}
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        {:ok, dir} = File.cwd()
        Prevalent.Journaling.take_snapshot(actual_state)
        File.cd(dir)
        Prevalent.Journaling.delete_all_commands()
        File.cd(dir)
        {:reply, {:executed}, actual_state}
    end
end