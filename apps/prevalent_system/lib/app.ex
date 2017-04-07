defmodule Prevalent.App do
    @moduledoc ""

    use Application

    def start(_type, _args) do
        import Supervisor.Spec
        tree = [
            worker(Prevalent.SystemApi, [%{}, [name: :prevalent_system]])
        ]
        opts = [name: Prevalent.Sup, strategy: :one_for_one]
        Supervisor.start_link(tree, opts)
    end
  
end
