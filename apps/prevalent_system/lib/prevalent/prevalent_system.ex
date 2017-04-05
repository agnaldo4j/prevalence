defmodule Prevalent.System do
    use GenServer
    use Timex
    def handle_call({:execute, command}, _from, actual_state) do
        Prevalent.Journaling.log_command(command)
        |> execute_command(actual_state)
        |> response_execution
    end

    def handle_call({:reload_system}, _from, actual_state) do
        Prevalent.Journaling.load_system_state
        |> execute_all_commands
        |> response_execution
    end

    def execute_all_commands({saved_state, list_of_commands}) do
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
        |> response_execution
    end

    defp response_execution(actual_state) do
      {:reply, {:executed}, actual_state}
    end
end