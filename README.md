# prevayler_iex
[![Build Status](https://travis-ci.org/agnaldo4j/prevayler_iex.svg?branch=develop)](https://travis-ci.org/agnaldo4j/prevayler_iex)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/agnaldo4j/prevayler_iex.svg?branch=develop)](https://beta.hexfaktor.org/github/agnaldo4j/prevayler_iex) 
[![Inline docs](http://inch-ci.org/github/agnaldo4j/prevayler_iex.svg?branch=develop)](http://inch-ci.org/github/agnaldo4j/prevayler_iex)
[![Coverage Status](https://coveralls.io/repos/github/agnaldo4j/prevayler_iex/badge.svg)](https://coveralls.io/github/agnaldo4j/prevayler_iex)
[![hex.pm version](https://img.shields.io/hexpm/v/prevayler_iex.svg?style=flat)](https://hex.pm/packages/prevayler_iex)
[![Ebert](https://ebertapp.io/github/agnaldo4j/prevayler_iex.svg)](https://ebertapp.io/github/agnaldo4j/prevayler_iex)

*“You can sell your time, but you can never buy it back. So the price of everything in life is the amount of time you spend on it.” @yanaga*

## Important

This lib requires Erlang 19 or newer. Because I use 

```Elixir
:os.system_time(:nanosecond)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `prevayler_iex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:prevayler_iex, "~> 0.1.7"}]
end
```

Add application to start
```elixir
def application do
    [applications: [:prevayler_iex]]
  end
```

And configure database location, if you don't change this are the default config
```elixir
config :prevayler_iex, Prevalent.Journaling,
       snapshot_path: "db/snapshot",
       commands_path: "db/commands"
```

You can see how it works in this [file](https://github.com/agnaldo4j/prevayler_iex/blob/develop/test/prevalent_system_test.exs)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/prevayler_iex](https://hexdocs.pm/prevayler_iex).