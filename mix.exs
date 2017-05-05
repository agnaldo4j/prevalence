defmodule Prevalence.Mixfile do
  use Mix.Project

  def project do
    [
      app: :prevayler-iex,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: Coverex.Task],
      description: description(),
      package: package(),
      name: "prevayler-iex",
      source_url: "https://github.com/agnaldo4j/prevalence.git"
    ]
  end

  defp description do
    """
    Simple implementation of prevalence in Elixir, this project is based on prevayler project (https://github.com/jsampson/prevayler.git).
    """
  end

  defp package do
    # These are the default files included in the package
    [
      name: :prevayler-iex,
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["Agnaldo de Oliveira"],
      licenses: ["BSD 3-clause"],
      links: %{"GitHub" => "https://github.com/elixir-ecto/postgrex"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: [:logger],
      mod: {
          Prevalent.App, []
      }
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:timex, "~> 3.0"},
      {:credo, "~> 0.7", only: [:dev, :test]},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:coverex, "~> 1.4.12", only: :test}
    ]
  end
end
