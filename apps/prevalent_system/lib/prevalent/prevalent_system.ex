defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        Prevalent.Journaling.log_command(command)
        |> execute_command(actual_state)
        |> response_execution
    end

    def handle_call({:reload_system}, _from, actual_state) do
        saved_state = Prevalent.Journaling.load_snapshot()
        list_of_commands = Prevalent.Journaling.load_list_of_commands()
        execute_all_commands(list_of_commands, saved_state)
        |> response_execution
    end

    def execute_all_commands(list_of_commands, saved_state) do
        List.foldr(list_of_commands, saved_state, fn(path, acc) ->
            Prevalent.Journaling.load_command(path)
            |> execute_command(saved_state)
        end)
    end

    def execute_command({function, data}, actual_state) do
      function.(actual_state, data)
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        Prevalent.Journaling.take_snapshot(actual_state)
        Prevalent.Journaling.delete_all_commands()
        response_execution(actual_state)
    end

    defp response_execution(actual_state) do
      {:reply, {:executed}, actual_state}
    end
end