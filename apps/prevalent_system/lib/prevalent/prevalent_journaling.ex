defmodule Prevalent.Journaling do

    def log_command(command) do
        {:ok, str_time} = Timex.format(Timex.now, "{ISO:Extended}")
        File.mkdir_p("commands")
        File.cd!("commands", fn() ->
            {:ok, file} = File.open "command_"<>str_time<>".dat", [:write]
            IO.binwrite file, :erlang.term_to_binary(command)
            File.close file
        end)
    end

    def load_snapshot() do
        File.cd!("snapshot", fn() ->
            case File.read("prevalent_system.dat") do
                {:ok, system_binary} -> :erlang.binary_to_term(system_binary)
                {:error, error} -> %{}
            end
        end)
    end

    def take_snapshot(actual_state) do
      File.mkdir_p("snapshot")
      File.cd!("snapshot", fn() ->
          {:ok, file} = File.open "prevalent_system.dat", [:write]
          IO.binwrite file, :erlang.term_to_binary(actual_state)
          File.close file
      end)
    end

    def delete_all_commands() do
      File.cd!("commands", fn() ->
          {:ok, list_of_commands} = File.ls(".")
          Enum.each(list_of_commands, fn(path) -> File.rm(path) end)
      end)
    end

    def load_list_of_commands() do
        File.cd!("commands", fn() ->
            {:ok, list_of_commands} = File.ls(".")
            list_of_commands
        end)
    end

    def load_command(path) do
      File.cd!("commands", fn() -> File.read(path) end)
    end
end