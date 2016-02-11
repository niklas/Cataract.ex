defmodule Cataract.Mixfile do
  use Mix.Project

  def project do
    [app: :cataract,
     version: "0.3.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Cataract, []},
     applications: app_list(Mix.env)
     ]
  end

  def app_list do
    [
      :phoenix,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :postgrex,
      :afunix,
      :xmlrpc,
      :erlsom,
    ]
  end

  def app_list(:test), do: [:hound | app_list]
  def app_list(_),     do: app_list

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.0"},
     {:phoenix_ecto, "~> 2.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.3"},
     {:ja_serializer, "~> 0.7.0"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:mix_test_watch, github: "niklas/mix-test.watch", branch: "feature/single-file-first", only: :dev},
     {:floki, "~> 0.7.1", only: :test},
     {:hound, "~> 0.8.2"},
     {:gettext, "~> 0.9"},
     {:afunix, github: "tonyrog/afunix"},
     {:elixir_bencode, "~> 1.0.0"},
     {:erlsom, github: "willemdj/erlsom"},
     {:xmlrpc, github: "niklas/elixir-xml_rpc", branch: "feature/64-bit-integers"},
     {:exrm, "~> 0.19.9"},
     {:cowboy, "~> 1.0"}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
