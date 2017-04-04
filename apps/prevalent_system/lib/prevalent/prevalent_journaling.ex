defmodule Prevalent.Journaling do
  @moduledoc false

    def log_command(command) do
        {:ok, str_time} = Timex.format(Timex.now, "{ISO:Extended}")
        {:ok, dir} = File.cwd()
        File.mkdir_p("commands")
        File.cd("commands")
        {:ok, file} = File.open "command_"<>str_time<>".dat", [:write]
        IO.binwrite file, :erlang.term_to_binary(command)
        File.close file
        File.cd(dir)
    end

    def load_snapshot() do
        File.cd("snapshot")
        case File.read("prevalent_system.dat") do
            {:ok, system_binary} -> :erlang.binary_to_term(system_binary)
            {:error, error} -> %{}
        end
    end

    def take_snapshot(actual_state) do
      File.mkdir_p("snapshot")
      File.cd("snapshot")
      {:ok, file} = File.open "prevalent_system.dat", [:write]
      IO.binwrite file, :erlang.term_to_binary(actual_state)
      File.close file
    end

    def delete_all_commands() do
      File.cd("commands")
      {:ok, list_of_commands} = File.ls(".")
      Enum.each(list_of_commands, fn(path) -> File.rm(path) end)
    end

    def load_list_of_commands() do
        File.cd("commands")
        {:ok, list_of_commands} = File.ls(".")
        list_of_commands
    end

    def load_command(path) do
      File.cd("commands")
      File.read(path)
    end
end