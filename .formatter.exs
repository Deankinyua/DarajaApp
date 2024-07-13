[
  import_deps: [
    :ecto,
    :ecto_sql,
    :phoenix,
    :phoenix,
    # add these lines -->
    :ash,
    :ash_authentication,
    :ash_authentication_phoenix,
    :ash_postgres
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
