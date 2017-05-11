defmodule Prevalent.System do
    @moduledoc ""

    use GenServer
    alias Prevalent.Journaling, as: Journaling

    def handle_call({:execute, command}, _from, actual_state) do
        command
        |> Journaling.log_command
        |> execute_command(actual_state)
        |> response_execution
    end

    def handle_call({:query, command}, _from, actual_state) do
        command
        |> execute_query(actual_state)
        |> response_query(actual_state)
    end

    def handle_call({:reload_system}, _from, _actual_state) do
        Journaling.load_system_state
        |> execute_all_commands
        |> response_execution
    end

    def handle_call({:take_snapshot}, _from, actual_state) do
        actual_state
        |> Journaling.take_snapshot
        |> response_execution
    end

    def handle_call({:erase_data}, _from, _actual_state) do
        Journaling.erase_data
        |> response_execution
    end

    defp execute_all_commands({saved_state, list_of_commands}) do
        Enum.reduce(list_of_commands, saved_state, fn(path, actual_state) ->
            path
            |> Journaling.load_command
            |> execute_command(actual_state)
        end)
    end

    defp execute_command({function, data}, actual_state) do
      function.(actual_state, data)
    end

    defp execute_query({function, criteria}, actual_state) do
      function.(actual_state, criteria)
    end

    defp response_execution(actual_state) do
      {:reply, {:executed}, actual_state}
    end

    defp response_query(result, actual_state) do
      {:reply, result, actual_state}
    end
end
