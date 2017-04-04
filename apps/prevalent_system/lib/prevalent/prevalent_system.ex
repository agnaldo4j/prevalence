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
        saved_state = Prevalent.Journaling.load_snapshot()
        list_of_commands = Prevalent.Journaling.load_list_of_commands()

        result = List.foldr(list_of_commands, saved_state, fn(path, acc) ->
            command = Prevalent.Journaling.load_command(path)
            {function, data} = command
            function.(saved_state, data)
        end)

        {:reply, {:executed, result}, result}
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        Prevalent.Journaling.take_snapshot(actual_state)
        Prevalent.Journaling.delete_all_commands()
        {:reply, {:executed}, actual_state}
    end
end