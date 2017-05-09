defmodule Prevalent.Journaling do
    @moduledoc ""

    defp write_binary(file_name, binary_data) do
        {:ok, file} = File.open file_name, [:write]
        IO.binwrite file, :erlang.term_to_binary(binary_data)
        File.close file
    end

    def log_command(command) do
        File.mkdir_p(commands_path())
        time = Integer.to_string(:os.system_time(:milli_seconds))
        File.cd!(commands_path(), fn() -> write_binary(time <> "_command.dat", command) end)
        command
    end

    def load_system_state do
      snapshot = load_snapshot()
      list_of_commands = load_list_of_commands()
      {snapshot, list_of_commands}
    end

    def load_snapshot do
        File.mkdir_p(snapshot_path())
        File.cd!(snapshot_path(), fn() ->
            case File.read("prevalent_system.dat") do
                {:ok, system_binary} -> :erlang.binary_to_term(system_binary)
                {:error, _error} -> %{}
            end
        end)
    end

    def take_snapshot(actual_state) do
      File.mkdir_p(snapshot_path())
      File.cd!(snapshot_path(), fn() -> write_binary("prevalent_system.dat", actual_state) end)
      delete_all_commands()
      actual_state
    end

    def delete_all_commands do
      File.cd!(commands_path(), fn() ->
          {:ok, list_of_commands} = File.ls(".")
          Enum.each(list_of_commands, fn(path) -> File.rm(path) end)
      end)
    end

    def load_list_of_commands do
        File.mkdir_p(commands_path())
        File.cd!(commands_path(), fn() ->
            {:ok, list_of_commands} = File.ls(".")
            list_of_commands
        end)
    end

    def load_command(path) do
      case File.cd!(commands_path(), fn() -> File.read(path) end) do
        {:ok, binary} -> :erlang.binary_to_term(binary)
        {:error, _reason} -> {fn(actual_state, _data) -> actual_state end, ""}
      end
    end

    defp snapshot_path() do
        configs = Application.get_env(:prevayler_iex, Prevalent.Journaling)
        IO.puts("snapshot: ")
        configs[:snapshot_path]
    end

    defp commands_path() do
        configs = Application.get_env(:prevayler_iex, Prevalent.Journaling)
        IO.puts("commands: ")
        configs[:commands_path]
    end
end
