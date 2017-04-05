defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        Prevalent.Journaling.log_command(command)
        result = execute_command(command, actual_state)
        {:reply, {:executed, result}, result}
    end

    def handle_call({:reload_system}, _from, actual_state) do
        saved_state = Prevalent.Journaling.load_snapshot()
        list_of_commands = Prevalent.Journaling.load_list_of_commands()

        result = List.foldr(list_of_commands, saved_state, fn(path, acc) ->
            Prevalent.Journaling.load_command(path)
            |> execute_command(saved_state)
        end)

        {:reply, {:executed, result}, result}
    end

    def execute_command({function, data}, actual_state) do
      function.(actual_state, data)
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        Prevalent.Journaling.take_snapshot(actual_state)
        Prevalent.Journaling.delete_all_commands()
        {:reply, {:executed}, actual_state}
    end
end