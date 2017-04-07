defmodule Prevalent.System do
    @moduledoc ""

    use GenServer
    use Prevalent.Journaling

    def handle_call({:execute, command}, _from, actual_state) do
        command
        |> log_command
        |> execute_command(actual_state)
        |> response_execution
    end

    def handle_call({:reload_system}, _from, actual_state) do
        load_system_state
        |> execute_all_commands
        |> response_execution
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        actual_state
        |> take_snapshot
        |> response_execution
    end

    defp execute_all_commands({saved_state, list_of_commands}) do
        List.foldr(list_of_commands, saved_state, fn(path, acc) ->
            path
            |> load_command
            |> execute_command(saved_state)
        end)
    end

    defp execute_command({function, data}, actual_state) do
      function.(actual_state, data)
    end

    defp response_execution(actual_state) do
      {:reply, {:executed}, actual_state}
    end
end
