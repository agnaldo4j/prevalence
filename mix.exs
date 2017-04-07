defmodule Prevalence.Mixfile do
  use Mix.Project

  def project do
    [
        apps_path: "apps",
        build_embedded: Mix.env == :prod,
        start_permanent: Mix.env == :prod,
        deps: deps(),
        version: "0.0.1",
        elixir: "1.2.0",
        description: description(),
        package: package()
    ]
  end

    defp description do
        """"""
    end

    defp package do
    [
        # These are the default files included in the package
        name: :postgrex,
        files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
        maintainers: ["Agnaldo de Oliveira"],
        licenses: ["Apache 2.0"],
        links: %{"GitHub" => "https://github.com/agnaldo4j/prevalence"}]
    end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
        {:credo, "~> 0.7", only: [:dev, :test]},
        {:inch_ex, only: :docs}
    ]
  end
end
